###############################
### Terraform Configuration ###
###############################

provider "google" {
  region = "asia-southeast1"
}

terraform {
  backend "gcs" {
  }
}

######################
### Module Project ###
######################

module "project" {
  source = "../../../tf-modules/gcp/project"

  project_name    = var.project_name
  project_id      = var.project_id
  org_id          = var.org_id
  billing_account = var.billing_account
}

##################
### Module GCS ###
##################

module "gcs" {
  source = "../../../tf-modules/gcp/gcs"

  project = module.project.project_id

  bucket_name     = var.bucket_name
  bucket_location = var.bucket_location
  labels          = var.labels

  asset_path = var.asset_path
  mime_types = var.mime_types

  index_suffix = var.index_suffix
  error_file   = var.error_file
}
