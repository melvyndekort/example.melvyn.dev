resource "aws_cloudfront_origin_access_identity" "example" {
  comment = "Identity for example.melvyn.dev"
}

resource "aws_cloudfront_public_key" "example" {
  name        = "example-melvyn-dev"
  comment     = "Public key for example.melvyn.dev"
  encoded_key = var.cloudfront_public_key
}

resource "aws_cloudfront_key_group" "example" {
  name    = "example-melvyn-dev"
  comment = "Key group for example.melvyn.dev"
  items   = [aws_cloudfront_public_key.example.id]
}

data "aws_cloudfront_cache_policy" "caching_disabled" {
  name = "Managed-CachingDisabled"
}

resource "aws_cloudfront_distribution" "example" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "Example website for cloudfront signed cookies setup"
  price_class     = "PriceClass_100"

  default_root_object = "index.html"

  aliases = [aws_acm_certificate.example.domain_name]

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = aws_acm_certificate_validation.example.certificate_arn
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  origin {
    origin_id   = "example"
    domain_name = aws_s3_bucket.example.bucket_regional_domain_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.example.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    target_origin_id = "example"

    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id = data.aws_cloudfront_cache_policy.caching_disabled.id

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    trusted_key_groups = [aws_cloudfront_key_group.example.id]
  }

  ordered_cache_behavior {
    path_pattern     = "/error-pages/*"
    target_origin_id = "example"

    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id = data.aws_cloudfront_cache_policy.caching_disabled.id

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
  }

  ordered_cache_behavior {
    path_pattern     = "/assets/*"
    target_origin_id = "example"

    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id = data.aws_cloudfront_cache_policy.caching_disabled.id

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
  }

  ordered_cache_behavior {
    path_pattern     = "/callback.html"
    target_origin_id = "example"

    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id = data.aws_cloudfront_cache_policy.caching_disabled.id

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
  }

  logging_config {
    bucket          = data.aws_s3_bucket.access_logs.bucket_domain_name
    include_cookies = true
    prefix          = "${aws_acm_certificate.example.domain_name}/"
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 403
    response_code         = 403
    response_page_path    = "/error-pages/403.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}