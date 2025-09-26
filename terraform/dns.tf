resource "cloudflare_dns_record" "example" {
  zone_id = data.terraform_remote_state.tf_cloudflare.outputs.melvyn_dev_zone_id
  name    = aws_acm_certificate.example.domain_name
  type    = "CNAME"
  ttl     = 300
  content = aws_cloudfront_distribution.example.domain_name
}
