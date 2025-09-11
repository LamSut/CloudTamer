variable "cluster" {}
variable "task_family" {}
variable "execution_role_arn" {}
variable "task_role_arn" {}

variable "vpc" {}
variable "private_subnet_ids" { type = list(string) }
variable "sg_http" {}
variable "sg_be" {}

variable "be_container_definitions" {}
variable "be_port" {}
variable "be_count" {}
