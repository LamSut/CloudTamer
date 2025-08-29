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

variable "ecr_force_delete" {
  description = "Whether to force delete the ECR repositories"
  type        = bool
  default     = true # Change to false to prevent accidental deletions
}


############################
### Docker Configuration ###
############################

variable "get_dockerfiles_command" {
  description = "Command to get the docker-compose file"
  type        = string
  default     = "bash ../../../shared/docker/get.sh"
}

variable "docker_images" {
  description = "Map of services to be built with their context and tags"

  type = map(object({
    context = string
    tag     = string
  }))

  default = {
    frontend = {
      context = "./repo/frontend"
      tag     = "v1"
    }
    backend = {
      context = "./repo/backend-api"
      tag     = "v1"
    }
  }
}


#########################
### ECS Configuration ###
#########################

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "pizza-cluster"
}

variable "task_family" {
  description = "Family name for the ECS task definition"
  type        = string
  default     = "pizza-task"
}

variable "fe_count" {
  description = "Number of Frontend service instances"
  type        = number
  default     = 2
}

variable "be_count" {
  description = "Number of Backend service instances"
  type        = number
  default     = 3
}
