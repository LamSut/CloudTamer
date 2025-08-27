#########################
### VPC Configuration ###
#########################

variable "default_cidr" {
  type    = string
  default = "0.0.0.0/0"
}


###########################
### VPC A Configuration ###
###########################

variable "vpc_a_cidr" {
  type    = string
  default = "10.0.0.0/16"
}


#########################
### ECR Configuration ###
#########################

variable "docker_images" {
  description = "Map of services to be built with their context and tags"

  type = map(object({
    context = string
    tag     = string
  }))

  default = {
    frontend = {
      context = "./repo/frontend"
      tag     = "v2"
    }
    backend = {
      context = "./repo/backend-api"
      tag     = "v1"
    }
  }
}

variable "ecr_force_delete" {
  description = "Whether to force delete the ECR repositories"
  type        = bool
  default     = true # Change to false to prevent accidental deletions
}

variable "get_dockerfiles_command" {
  description = "Command to get the docker-compose file"
  type        = string
  default     = "bash ../../../shared/docker/get.sh"
}
