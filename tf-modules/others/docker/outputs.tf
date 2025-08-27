output "image_urls" {
  description = "Docker Image URLs"
  value       = { for img in docker_image.docker_images : img.name => img.name }
}
