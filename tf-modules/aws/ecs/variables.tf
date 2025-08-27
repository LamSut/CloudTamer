variable "cluster_name" {}
variable "task_family" {}
variable "execution_role_arn" {}
variable "task_role_arn" {}
variable "container_definitions" {}
variable "subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }
