###############################
### Terraform Configuration ###
###############################

provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  backend "s3" {}
}

#################
### Module S3 ###
#################

module "s3_static_site" {
  source = "../../../tf-modules/aws/s3"

  static_policy = var.static_policy
  asset_path    = var.asset_path
}
