provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "limtruong-bucket"
    key    = "limtruong-state"
    region = "us-east-1"
  }
}


##################
### Module VPC ###
##################

module "vpc" {
  source = "../../../tf-modules/aws/vpc"
}


##################
### Module EC2 ###
##################

module "ec2" {
  source           = "../../../tf-modules/aws/ec2"
  public_subnet_1  = module.vpc.public_subnet_1
  private_subnet_1 = module.vpc.private_subnet_1
  private_subnet_2 = module.vpc.private_subnet_2
  sg_ssh           = module.vpc.sg_ssh
  sg_rdp           = module.vpc.sg_rdp
  sg_rds_ec2       = module.vpc.sg_rds_ec2
}

##################
### Module RDS ###
##################

# module "rds" {
#   source           = "../../../tf-modules/aws/rds"
#   vpc              = module.vpc.vpc
#   sg_rds_ec2       = module.vpc.sg_rds_ec2
#   private_subnet_1 = module.vpc.private_subnet_1
#   private_subnet_2 = module.vpc.private_subnet_2
# }

# output "mysql_connect_cmd" {
#   description = "MySQL CLI connection string"
#   value       = "mysql -h ${module.rds.mysql_endpoint} -u limtruong -plimkhietngoingoi limdb"
# }


#################
### Module S3 ###
#################

# module "s3_static_site" {
#   source = "../../../tf-modules/aws/s3"
# }

# output "static_website_url" {
#   description = "URL to access the static website"
#   value       = module.s3_static_site.static_website_url
# }
