###############################
### Terraform Configuration ###
###############################

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {}
}

#################
### Module S3 ###
#################

module "s3_static_site" {
  source = "../../../tf-modules/aws/s3"
}
