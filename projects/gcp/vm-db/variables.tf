#################################
### GCP Project Configuration ###
#################################

variable "project_name" {
  description = "Name of the GCP project"
  type        = string
  default     = "vm-db"
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "vm-db-363636"
}

variable "org_id" {
  description = "GCP organization ID"
  type        = string
}

variable "billing_account" {
  description = "GCP billing account ID"
  type        = string
}


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

variable "vpc_a_public_subnet_1_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "vpc_a_private_subnet_1_cidr" {
  type    = string
  default = "10.0.101.0/24"
}

variable "vpc_a_private_subnet_2_cidr" {
  type    = string
  default = "10.0.102.0/24"
}


###########################
### VPC B Configuration ###
###########################

variable "vpc_b_public_subnet_1_cidr" {
  type    = string
  default = "10.1.1.0/24"
}

variable "vpc_b_private_subnet_1_cidr" {
  type    = string
  default = "10.1.101.0/24"
}

variable "vpc_b_private_subnet_2_cidr" {
  type    = string
  default = "10.1.102.0/24"
}
