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


##################
### Module GCS ###
##################

module "gcs" {
  source = "../../../tf-modules/gcp/gcs"

  project = var.project

  bucket_name     = var.bucket_name
  bucket_location = var.bucket_location
  labels          = var.labels

  asset_path = var.asset_path
  mime_types = var.mime_types

  index_suffix = var.index_suffix
  error_file   = var.error_file
}
