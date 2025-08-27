terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}

resource "docker_image" "docker_images" {
  for_each = var.docker_images

  name = "${var.repo_urls[each.key]}:${each.value.tag}"
  build {
    context = each.value.context
  }
}

resource "docker_registry_image" "push_images" {
  for_each = var.docker_images

  name          = docker_image.docker_images[each.key].name
  keep_remotely = true
}
