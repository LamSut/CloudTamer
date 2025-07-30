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

  bucket_policy = var.bucket_policy
  asset_path    = var.asset_path
}

module "cloudfront" {
  source                = "../../../tf-modules/aws/cloudfront"
  static_website_domain = module.s3_static_site.static_website_domain
}
