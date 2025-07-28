##################
### Networking ###
##################

variable "public_subnet_1" {}
variable "private_subnet_1" {}
variable "private_subnet_2" {}
variable "sg_ssh" {}
variable "sg_rdp" {}
variable "sg_rds_ec2" {}


#####################
### EC2 Key Pairs ###
#####################

variable "key_name" {
  type    = string
  default = "b2111933-pair"
}


################
### EC2 AMIs ###
################

data "aws_ami" "ami_amazon_2023" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ami_ubuntu_2404" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ami_windows_2025" {
  most_recent = true
  owners      = ["801119661308"]

  filter {
    name   = "name"
    values = ["Windows_Server-2025-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


##########################
### EC2 Instance Types ###
##########################

variable "instance_small" {
  type    = string
  default = "t3.small"
}

variable "instance_medium" {
  type    = string
  default = "t3.medium"
}

variable "instance_large" {
  type    = string
  default = "t3.large"
}
