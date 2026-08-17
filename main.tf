resource "aws_s3_bucket" "s3bucket" {
    bucket = var.bucket_name 
}

resource "aws_s3_bucket_public_access_block" "block" {
    bucket = aws_s3_bucket.s3bucket.id

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_control" "oac" {
    name = "demo-oac"
    description = "Example policy"
    origin_access_control_origin_type = "s3"
    signing_behavior = "always"
    signing_protocol = "sigv4"   
}

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

