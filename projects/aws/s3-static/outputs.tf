#########################
### Terraform Outputs ###
#########################

output "static_website_url" {
  description = "URL to access the static website"
  value       = module.s3_static_site.static_website_url
}
