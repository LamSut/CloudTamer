variable "vpc" {}
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }
variable "cluster_name" {}
variable "sg_http" {}
