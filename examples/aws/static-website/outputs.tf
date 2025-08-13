#########################
### Terraform Outputs ###
#########################

output "static_website_url" {
  description = "URL to access the static website"
  value       = module.s3.static_website_url
}

output "cloudfront_url" {
  description = "CloudFront distribution URL"
  value       = "https://${module.cloudfront.cloudfront_domain_name}"
}
