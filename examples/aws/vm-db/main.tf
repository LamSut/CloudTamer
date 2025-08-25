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

data "aws_region" "region_a" {
  provider = aws.singapore
}

data "aws_region" "region_b" {
  provider = aws.virgin
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
  vpc_a_dst_cidr = module.vpc_b.vpc_cidr

  vpc_a_cidr                  = var.vpc_a_cidr
  vpc_a_public_subnet_1_cidr  = var.vpc_a_public_subnet_1_cidr
  vpc_a_public_subnet_2_cidr  = var.vpc_a_public_subnet_2_cidr
  vpc_a_private_subnet_1_cidr = var.vpc_a_private_subnet_1_cidr
  vpc_a_private_subnet_2_cidr = var.vpc_a_private_subnet_2_cidr
  vpc_a_availability_zone_1   = data.aws_availability_zones.region_a_azs.names[0]
  vpc_a_availability_zone_2   = data.aws_availability_zones.region_a_azs.names[1]
}


####################
### Module VPC B ###
####################

data "aws_availability_zones" "region_b_azs" {
  provider = aws.virgin
  state    = "available"
}

module "vpc_b" {
  source = "../../../tf-modules/aws/vpc/vpc-b"
  providers = {
    aws = aws.virgin
  }

  default_cidr   = var.default_cidr
  vpc_b_dst_cidr = module.vpc_a.vpc_cidr

  vpc_b_cidr                  = var.vpc_b_cidr
  vpc_b_public_subnet_1_cidr  = var.vpc_b_public_subnet_1_cidr
  vpc_b_public_subnet_2_cidr  = var.vpc_b_public_subnet_2_cidr
  vpc_b_private_subnet_1_cidr = var.vpc_b_private_subnet_1_cidr
  vpc_b_private_subnet_2_cidr = var.vpc_b_private_subnet_2_cidr
  vpc_b_availability_zone_1   = data.aws_availability_zones.region_b_azs.names[0]
  vpc_b_availability_zone_2   = data.aws_availability_zones.region_b_azs.names[1]
}


##########################
### Module VPC Peering ###
##########################

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
  peer_region      = data.aws_region.region_b.region
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

  sg_http_a = module.vpc_a.sg_http
  sg_ssh_a  = module.vpc_a.sg_ssh
  sg_rdp_a  = module.vpc_a.sg_rdp

  sg_http_b = module.vpc_b.sg_http
  sg_ssh_b  = module.vpc_b.sg_ssh
  sg_rdp_b  = module.vpc_b.sg_rdp

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
  sg_rds_ec2       = module.vpc_a.sg_rds_ec2

  family                  = var.family
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  db_username             = var.db_username
  db_password             = var.db_password
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
}
