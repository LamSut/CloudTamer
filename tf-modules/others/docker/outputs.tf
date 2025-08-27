output "image_urls" {
  description = "Docker Image URLs"
  value       = { for k, img in docker_image.docker_images : k => img.name }
}
