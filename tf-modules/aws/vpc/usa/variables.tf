variable "default_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "public_subnet_1_cidr" {
  type    = string
  default = "10.1.1.0/24"
}

variable "private_subnet_1_cidr" {
  type    = string
  default = "10.1.101.0/24"
}

variable "private_subnet_2_cidr" {
  type    = string
  default = "10.1.102.0/24"
}

variable "availability_zone_1" {
  type    = string
  default = "us-east-1a"
}

variable "availability_zone_2" {
  type    = string
  default = "us-east-1b"
}


