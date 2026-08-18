output "cloudfront_url" {
    description = "URL to access your website via CloudFront"
    value       = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
}

output "s3_bucket_name" {
    description = "Name of the S3 bucket"
    value       = aws_s3_bucket.s3bucket.bucket
}