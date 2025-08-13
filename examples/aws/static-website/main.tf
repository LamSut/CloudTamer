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

module "s3" {
  source = "../../../tf-modules/aws/s3"

  bucket_name   = var.bucket_name
  bucket_policy = var.bucket_policy
  tags          = local.tags

  asset_path = var.asset_path
  mime_types = local.mime_types

  index_suffix = var.index_suffix
  error_file   = var.error_file
}


#########################
### Module CloudFront ###
#########################

module "cloudfront" {
  source                = "../../../tf-modules/aws/cloudfront"
  static_website_domain = module.s3.static_website_domain
}
