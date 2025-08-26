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

variable "ecr_repo_names" {
  description = "List of ECR repository names to create"
  type        = list(string)
  default     = ["frontend", "backend"]
}

variable "local_image_names" {
  description = "List of local Docker image names (must match docker-compose build)"
  type        = list(string)
  default     = ["frontend:v1", "backend:v1"]
}

variable "ecr_force_delete" {
  description = "Whether to force delete the ECR repositories"
  type        = bool
  default     = true # Change to false to prevent accidental deletions
}

variable "get_docker_compose_command" {
  description = "Command to get the docker-compose file"
  type        = string
  default     = "bash ../../../shared/docker-compose/get.sh"
}
