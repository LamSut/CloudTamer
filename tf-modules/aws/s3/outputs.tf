output "static_website_url" {
  description = "URL to access the static website"
  value       = "http://${aws_s3_bucket.static_website.bucket}.s3-website-${data.aws_region.current.id}.amazonaws.com"
}

output "static_website_domain" {
  description = "S3 static website endpoint"
  value       = "${aws_s3_bucket.static_website.bucket}.s3-website-${data.aws_region.current.id}.amazonaws.com"
}
