output "static_website_url" {
  description = "URL to access the static website"
  value       = "http://${aws_s3_bucket.static_site.bucket}.s3-website-${data.aws_region.current.id}.amazonaws.com"
}
