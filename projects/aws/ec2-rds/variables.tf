###########################
### EC2 Instances Coumt ###
###########################

variable "amazon_count" {
  type    = number
  default = 1
}

variable "ubuntu_count" {
  type    = number
  default = 1
}

variable "windows_count" {
  type    = number
  default = 0
}


#####################
### EC2 Key Pairs ###
#####################

variable "key_name" {
  type    = string
  default = "limtruong-pair"
}


##########################
### EC2 Instance Types ###
##########################

variable "instance_type" {
  type    = string
  default = "t3.small"
}
