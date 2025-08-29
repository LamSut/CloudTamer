variable "cluster_name" {}
variable "task_family" {}
variable "execution_role_arn" {}
variable "task_role_arn" {}
variable "subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }

variable "fe_container_definitions" {}
variable "be_container_definitions" {}

variable "fe_count" {}
variable "be_count" {}
