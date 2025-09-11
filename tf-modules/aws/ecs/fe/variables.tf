variable "cluster" {}
variable "task_family" {}
variable "execution_role_arn" {}
variable "task_role_arn" {}

variable "vpc" {}
variable "private_subnet_ids" { type = list(string) }
variable "sg_http" {}
variable "sg_fe" {}

variable "fe_container_definitions" {}
variable "fe_port" {}
variable "fe_tg_arn" {}
variable "fe_count" {}
