data "aws_route53_zone" "melvyn_dev" {
  name = "melvyn.dev"
}

resource "aws_acm_certificate" "example" {
  provider = aws.useast1

  domain_name       = "example.melvyn.dev"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "example_cert_validate" {
  for_each = {
    for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.melvyn_dev.zone_id
}

resource "aws_acm_certificate_validation" "example" {
  provider = aws.useast1

  certificate_arn         = aws_acm_certificate.example.arn
  validation_record_fqdns = [for record in aws_route53_record.example_cert_validate : record.fqdn]
}

resource "aws_route53_record" "example-a" {
  name    = aws_acm_certificate.example.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.melvyn_dev.zone_id

  alias {
    name                   = aws_cloudfront_distribution.example.domain_name
    zone_id                = aws_cloudfront_distribution.example.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "example-aaaa" {
  name    = aws_acm_certificate.example.domain_name
  type    = "AAAA"
  zone_id = data.aws_route53_zone.melvyn_dev.zone_id

  alias {
    name                   = aws_cloudfront_distribution.example.domain_name
    zone_id                = aws_cloudfront_distribution.example.hosted_zone_id
    evaluate_target_health = false
  }
}
