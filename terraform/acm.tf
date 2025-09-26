resource "aws_acm_certificate" "example" {
  provider = aws.useast1

  domain_name       = "example.melvyn.dev"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "cloudflare_dns_record" "example_cert_validate" {
  for_each = {
    for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = data.terraform_remote_state.tf_cloudflare.outputs.melvyn_dev_zone_id
  name    = trim(each.value.name, ".")
  type    = each.value.type
  ttl     = 60
  content = trim(each.value.record, ".")
}

resource "aws_acm_certificate_validation" "example" {
  provider = aws.useast1

  certificate_arn         = aws_acm_certificate.example.arn
  validation_record_fqdns = [for record in cloudflare_dns_record.example_cert_validate : record.name]
}
