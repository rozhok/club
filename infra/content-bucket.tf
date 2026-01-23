variable "aws_profile" {
  description = "AWS profile"
  default = "prod"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "club origin access identity"
}

resource "aws_s3_bucket" "content_bucket" {
  bucket = "club-prod"

  tags = {
    Name         = "content-bucket"
    Environment  = var.aws_profile
    microservice = "club"
  }
}

resource "aws_s3_bucket_cors_configuration" "content_bucket_cors" {
  bucket = aws_s3_bucket.content_bucket.id

  cors_rule {
    allowed_headers = [ "*" ]
    allowed_methods = [ "GET", "HEAD", "POST", "PUT" ]
    allowed_origins = [ "*" ]
    max_age_seconds = 3000
    expose_headers  = [ "ETag" ]
  }
}

data "aws_iam_policy_document" "content_bucket_policy_document" {
  statement {
    actions   = [ "s3:GetObject" ]
    resources = [ "${aws_s3_bucket.content_bucket.arn}/*" ]

    principals {
      type        = "AWS"
      identifiers = [ aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn ]
    }
  }

  statement {
    actions   = [ "s3:ListBucket" ]
    resources = [ aws_s3_bucket.content_bucket.arn ]

    principals {
      type        = "AWS"
      identifiers = [ aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn ]
    }
  }
}

resource "aws_s3_bucket_policy" "content_bucket_policy" {
  bucket = aws_s3_bucket.content_bucket.id
  policy = data.aws_iam_policy_document.content_bucket_policy_document.json
}

locals {
  s3_origin_id = "club-content-s3-origin"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.content_bucket.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled         = true
  is_ipv6_enabled = true

  default_cache_behavior {
    allowed_methods  = [ "GET", "HEAD", "OPTIONS" ]
    cached_methods   = [ "GET", "HEAD" ]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = [ "Access-Control-Request-Headers", "Access-Control-Request-Method", "Origin" ]

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name         = "content-cdn"
    Environment  = var.aws_profile
    microservice = "club-app"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

output "cdn_url" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}


