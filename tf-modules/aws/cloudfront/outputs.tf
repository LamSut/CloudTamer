output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.static_website_distribution.domain_name
}
