output "images_urls" {
  description = "Docker Image URLs"
  value       = module.docker.image_urls
}

output "alb_dns_name" {
  description = "ALB DNS Name"
  value       = module.alb.alb_dns_name
}
