resource "aws_s3_bucket" "s3bucket" {
    bucket = var.bucket_name 
}

# BLOCK PUBLIC ACCESS - Security critical
resource "aws_s3_bucket_public_access_block" "block" {
    bucket = aws_s3_bucket.s3bucket.id

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

# ORIGIN ACCESS CONTROL - Allows CloudFront to access S3
resource "aws_cloudfront_origin_access_control" "oac" {
    name = "demo-oac"
    description = "Example policy"
    origin_access_control_origin_type = "s3"
    signing_behavior = "always"
    signing_protocol = "sigv4"   
}

# BUCKET POLICY - Grants read access ONLY to CloudFront
resource "aws_s3_bucket_policy" "allow_cf" {
    bucket = aws_s3_bucket.s3bucket.id

    depends_on = [
        aws_s3_bucket_public_access_block.block
    ]

    policy = jsonencode({
        Version = "2012-10-17"

        Statement = [
        {
            Sid    = "AllowCloudFront"
            Effect = "Allow"

            Principal = {
            Service = "cloudfront.amazonaws.com"
            }

            Action   = "s3:GetObject"
            Resource = "${aws_s3_bucket.s3bucket.arn}/*"

            Condition = {
            StringEquals = {
                "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
            }
            }
        }
        ]
    })
}

# Uploads all files from ./www directory
resource "aws_s3_object" "object" {
    for_each = fileset("${path.module}/www","**/*")
    bucket = aws_s3_bucket.s3bucket.bucket
    key    = each.value
    source = "${path.module}/www/${each.value}"
    etag = filemd5("${path.module}/www/${each.value}")

    content_type = lookup({
        "html" = "text/html"
        "css"  = "text/css"
        "js"   = "application/javascript"
        "png"  = "image/png"
        "jpg"  = "image/jpeg"
        "jpeg" = "image/jpeg"
        "gif"  = "image/gif"
        "svg"  = "image/svg+xml"
        "json" = "application/json"
        "txt"  = "text/plain"
    }, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")
} 

# Caches content at edge locations
resource "aws_cloudfront_distribution" "s3_distribution" {
    origin {
        # Uses S3 bucket's regional domain name
        domain_name              = aws_s3_bucket.s3bucket.bucket_regional_domain_name
        origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
        origin_id                = local.origin_id
    }

    enabled             = true
    is_ipv6_enabled     = true
    comment             = "Static website with CloudFront"
    default_root_object = "index.html"

    default_cache_behavior {
        allowed_methods  = ["GET", "HEAD"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = local.origin_id

        forwarded_values {
            query_string = false

            cookies {
                forward = "none"
            }
        }

        # Redirects HTTP to HTTPS automatically
        viewer_protocol_policy = "redirect-to-https"
        # Cache settings: no cache for fresh content, then 1 hour cache
        min_ttl                = 0
        default_ttl            = 3600
        max_ttl                = 86400
    }

    # PriceClass_100 uses only US and Europe edge locations
    price_class = "PriceClass_100"

    restrictions {
        geo_restriction {
        restriction_type = "none"
        }
    }

    tags = {
        Environment = "development"
    }

    # Uses free CloudFront SSL certificate
    viewer_certificate {
        cloudfront_default_certificate = true
    }
}