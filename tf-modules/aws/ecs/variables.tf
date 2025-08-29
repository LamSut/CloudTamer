variable "cluster_name" {}
variable "task_family" {}
variable "execution_role_arn" {}
variable "task_role_arn" {}

variable "vpc" {}
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }
variable "sg_http" {}

variable "fe_container_definitions" {}
variable "be_container_definitions" {}

variable "fe_port" {}
variable "be_port" {}

variable "fe_tg_arn" {}
variable "be_tg_arn" {}

variable "fe_count" {}
variable "be_count" {}
