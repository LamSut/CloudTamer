output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.static_site_distribution.domain_name
}
