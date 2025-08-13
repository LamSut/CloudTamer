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


########################
### VM Configuration ###
########################

variable "vm_user" {
  description = "Default user for VMs"
  type        = string
}

variable "win_count" {
  type    = number
  default = 1
}

variable "rhel_count" {
  type    = number
  default = 2
}

variable "debian_count" {
  type    = number
  default = 1
}

variable "win_machine_type" {
  type    = string
  default = "e2-small"
}

variable "rhel_machine_type" {
  type    = string
  default = "e2-small"
}

variable "debian_machine_type" {
  type    = string
  default = "e2-small"
}

variable "win_image" {
  type    = string
  default = "projects/windows-cloud/global/images/family/windows-2019"
}

variable "rhel_image" {
  type    = string
  default = "projects/rhel-cloud/global/images/family/rhel-8"
}

variable "debian_image" {
  type    = string
  default = "projects/debian-cloud/global/images/family/debian-11"
}

variable "zone_a1" {
  type    = string
  default = "asia-southeast1-a"
}

variable "zone_b1" {
  type    = string
  default = "us-central1-a"
}


