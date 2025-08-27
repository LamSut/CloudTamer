###############################
### Terraform Configuration ###
###############################

provider "aws" {
  alias  = "singapore"
  region = "ap-southeast-1"
}

data "aws_region" "region_a" {
  provider = aws.singapore
}

terraform {
  backend "s3" {}
}


####################
### Module VPC A ###
####################

data "aws_availability_zones" "region_a_azs" {
  provider = aws.singapore
  state    = "available"
}

module "vpc_a" {
  source = "../../../tf-modules/aws/vpc/vpc-a"
  providers = {
    aws = aws.singapore
  }

  default_cidr   = var.default_cidr
  vpc_a_dst_cidr = var.vpc_a_cidr

  vpc_a_cidr                = var.vpc_a_cidr
  vpc_a_availability_zone_1 = data.aws_availability_zones.region_a_azs.names[0]
  vpc_a_availability_zone_2 = data.aws_availability_zones.region_a_azs.names[1]
}


##################
### Module ECR ###
##################

module "ecr" {
  source = "../../../tf-modules/aws/ecr"
  providers = {
    aws = aws.singapore
  }

  ecr_repo_names   = var.docker_images
  ecr_force_delete = var.ecr_force_delete
}

resource "null_resource" "get_dockerfiles" {
  depends_on = [module.ecr]

  provisioner "local-exec" {
    command = var.get_dockerfiles_command
  }
}

