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

