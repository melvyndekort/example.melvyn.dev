data "aws_route53_zone" "melvyn_dev" {
  name = "melvyn.dev"
}

resource "aws_route53_record" "example_a" {
  name    = aws_acm_certificate.example.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.melvyn_dev.zone_id

  alias {
    name                   = aws_cloudfront_distribution.example.domain_name
    zone_id                = aws_cloudfront_distribution.example.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "example_aaaa" {
  name    = aws_acm_certificate.example.domain_name
  type    = "AAAA"
  zone_id = data.aws_route53_zone.melvyn_dev.zone_id

  alias {
    name                   = aws_cloudfront_distribution.example.domain_name
    zone_id                = aws_cloudfront_distribution.example.hosted_zone_id
    evaluate_target_health = false
  }
}
