###############################
### Terraform Configuration ###
###############################

provider "aws" {
  alias  = "singapore"
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "virgin"
  region = "us-east-1"
}

terraform {
  backend "s3" {}
}


##################
### Module VPC ###
##################

module "vpc_a" {
  source = "../../../tf-modules/aws/vpc/sing"
  providers = {
    aws = aws.singapore
  }
  vpc_dst_cidr = module.vpc_b.vpc_cidr
}

module "vpc_b" {
  source = "../../../tf-modules/aws/vpc/usa"
  providers = {
    aws = aws.virgin
  }
  vpc_dst_cidr = module.vpc_a.vpc_cidr
}

module "vpc_peering" {
  source = "../../../tf-modules/aws/vpc/peering"
  providers = {
    aws.a = aws.singapore
    aws.b = aws.virgin
  }
  vpc_a            = module.vpc_a.vpc
  vpc_b            = module.vpc_b.vpc
  vpc_a_cidr       = module.vpc_a.vpc_cidr
  vpc_b_cidr       = module.vpc_b.vpc_cidr
  vpc_a_public_rt  = module.vpc_a.public_rt
  vpc_b_public_rt  = module.vpc_b.public_rt
  vpc_a_private_rt = module.vpc_a.private_rt
  vpc_b_private_rt = module.vpc_b.private_rt
  peer_region      = var.peer_region
}

##################
### Module EC2 ###
##################

module "ec2" {
  source = "../../../tf-modules/aws/ec2"
  providers = {
    aws.a = aws.singapore
    aws.b = aws.virgin
  }

  amazon_count  = var.amazon_count
  ubuntu_count  = var.ubuntu_count
  windows_count = var.windows_count

  public_subnet_a1 = module.vpc_a.public_subnet_1
  public_subnet_b1 = module.vpc_b.public_subnet_1

  sg_ssh_a = module.vpc_a.sg_ssh
  sg_rdp_a = module.vpc_a.sg_rdp
  sg_ssh_b = module.vpc_b.sg_ssh
  sg_rdp_b = module.vpc_b.sg_rdp

  key_name      = var.key_name
  instance_type = var.instance_type
}

#################
## Module RDS ###
#################

module "rds" {
  source = "../../../tf-modules/aws/rds"
  providers = {
    aws = aws.singapore
  }

  vpc              = module.vpc_a.vpc
  private_subnet_1 = module.vpc_a.private_subnet_1
  private_subnet_2 = module.vpc_a.private_subnet_2

  sg_rds_ec2 = module.vpc_a.sg_rds_ec2
}
