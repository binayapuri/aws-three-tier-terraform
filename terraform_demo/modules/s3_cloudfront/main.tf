resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  force_destroy = true  # This setting may be needed to delete the bucket with content


  lifecycle_rule {
    enabled = true

    noncurrent_version_expiration {
      days = 30
    }
  }

  tags = {
    Name        = "MyWebsiteBucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_public_access_block" "s3Public" {
bucket = "${aws_s3_bucket.website_bucket.id}"
block_public_acls = true
block_public_policy = true
restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  acl    = "public-read"
  content_type = "text/html"
  source = "/home/binay/Hamropatro/asg-alb/asg-alb/terraform_demo/modules/s3_cloudfront/index.html"
}

# Uncomment the following block if you want to allow public read access to all objects in the bucket
resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.website_bucket.bucket
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "${aws_s3_bucket.website_bucket.arn}/*"
    }
  ]
}
EOF
}

output "static_website_url" {
  value = aws_s3_bucket.website_bucket.website_endpoint
}



resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id   = "S3-Website"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for S3 static website"
  default_root_object = "index.html"

  # Configure the default cache behavior
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-Website"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl               = 0
    default_ttl           = 3600
    max_ttl               = 86400
  }

  # Configure restrictions (allowing all traffic in this example)
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.website_distribution.domain_name
}