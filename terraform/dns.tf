data "cloudflare_zone" "melvyn_dev" {
  name = "melvyn.dev"
}

resource "cloudflare_record" "example" {
  zone_id = data.cloudflare_zone.melvyn_dev.id
  name    = aws_acm_certificate.example.domain_name
  type    = "CNAME"
  ttl     = "300"
  value   = aws_cloudfront_distribution.example.domain_name
}
