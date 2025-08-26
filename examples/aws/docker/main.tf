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

  vpc_a_cidr                  = var.vpc_a_cidr
  vpc_a_public_subnet_1_cidr  = var.vpc_a_public_subnet_1_cidr
  vpc_a_public_subnet_2_cidr  = var.vpc_a_public_subnet_2_cidr
  vpc_a_private_subnet_1_cidr = var.vpc_a_private_subnet_1_cidr
  vpc_a_private_subnet_2_cidr = var.vpc_a_private_subnet_2_cidr
  vpc_a_availability_zone_1   = data.aws_availability_zones.region_a_azs.names[0]
  vpc_a_availability_zone_2   = data.aws_availability_zones.region_a_azs.names[1]
}


##################
### Module ECR ###
##################

module "ecr" {
  source = "../../../tf-modules/aws/ecr"
  providers = {
    aws = aws.singapore
  }

  ecr_repo_names   = var.ecr_repo_names
  ecr_force_delete = var.ecr_force_delete
}

resource "null_resource" "get_docker_compose" {
  depends_on = [module.ecr]

  provisioner "local-exec" {
    command = var.get_docker_compose_command
  }
}

data "aws_caller_identity" "current" {}

locals {
  repo_pairs = [for i in range(length(var.ecr_repo_names)) : "${var.ecr_repo_names[i]}:${var.local_image_names[i]}"]
}

resource "null_resource" "push_ecr" {
  depends_on = [
    module.ecr,
    null_resource.get_docker_compose
  ]

  triggers = {
    image_names = join(",", var.local_image_names)
    repo_pairs  = join(",", local.repo_pairs)
  }

  provisioner "local-exec" {
    command = join(" ", concat([
      "./push.sh",
      data.aws_region.region_a.region,
      data.aws_caller_identity.current.account_id
    ], local.repo_pairs))
  }
}
