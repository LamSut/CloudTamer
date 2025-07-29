##################
### Networking ###
##################

variable "public_subnet_a1" {}
variable "public_subnet_b1" {}
variable "sg_ssh_a" {}
variable "sg_rdp_a" {}
variable "sg_ssh_b" {}
variable "sg_rdp_b" {}


#########################
### EC2 Configuartion ###
#########################

variable "amazon_count" {}
variable "ubuntu_count" {}
variable "windows_count" {}

variable "key_name" {}
variable "instance_type" {}
