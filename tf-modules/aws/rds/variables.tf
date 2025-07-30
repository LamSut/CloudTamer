##################
### Networking ###
##################

variable "vpc" {}
variable "private_subnet_1" {}
variable "private_subnet_2" {}
variable "sg_rds_ec2" {}

#########################
### RDS Configuration ###
#########################

variable "family" {}
variable "engine" {}
variable "engine_version" {}
variable "instance_class" {}
variable "allocated_storage" {}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {}
variable "backup_retention_period" {}
variable "backup_window" {}
