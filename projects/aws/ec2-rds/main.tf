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

module "vpc_sing" {
  source = "../../../tf-modules/aws/vpc/sing"
  providers = {
    aws = aws.singapore
  }
}

module "vpc_usa" {
  source = "../../../tf-modules/aws/vpc/usa"
  providers = {
    aws = aws.virgin
  }
}

module "vpc_peering" {
  source = "../../../tf-modules/aws/vpc/peering"
  providers = {
    aws.a = aws.singapore
    aws.b = aws.virgin
  }
  vpc_a            = module.vpc_sing.vpc
  vpc_b            = module.vpc_usa.vpc
  vpc_a_cidr_block = module.vpc_sing.vpc_cidr
  vpc_b_cidr_block = module.vpc_usa.vpc_cidr
  vpc_a_private_rt = module.vpc_sing.private_rt
  vpc_b_private_rt = module.vpc_usa.private_rt
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

  public_subnet_a1 = module.vpc_sing.public_subnet_1
  public_subnet_b1 = module.vpc_usa.public_subnet_1

  sg_ssh_a = module.vpc_sing.sg_ssh
  sg_rdp_a = module.vpc_sing.sg_rdp
  sg_ssh_b = module.vpc_usa.sg_ssh
  sg_rdp_b = module.vpc_usa.sg_rdp

  key_name      = var.key_name
  instance_type = var.instance_type
}

##################
### Module RDS ###
##################

# module "rds" {
#   source = "../../../tf-modules/aws/rds"
#   providers = {
#     aws = aws.singapore
#   }

#   vpc              = module.vpc_sing.vpc
#   private_subnet_1 = module.vpc_sing.private_subnet_1
#   private_subnet_2 = module.vpc_sing.private_subnet_2

#   sg_rds_ec2 = module.vpc_sing.sg_rds_ec2
# }
