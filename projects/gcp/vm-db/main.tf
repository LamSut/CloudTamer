###############################
### Terraform Configuration ###
###############################

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


##############################
### Provider Configuration ###
##############################

locals {
  region_singapore = "asia-southeast1"
  project_id       = module.project.project_id
}

provider "google" {
  alias   = "singapore"
  project = local.project_id
  region  = local.region_singapore
}


#######################
### Module Services ###
#######################

module "services" {
  source = "../../../tf-modules/gcp/services"
  providers = {
    google = google.singapore
  }
}

resource "null_resource" "wait" {
  depends_on = [module.services]

  provisioner "local-exec" {
    command = "sleep 30"
  }
}


####################
### Module VPC A ###
####################

module "vpc_a" {
  source = "../../../tf-modules/gcp/vpc/vpc-a"
  providers = {
    google = google.singapore
  }
  depends_on = [null_resource.wait]

  vpc_a_public_subnet_1_cidr = var.vpc_a_public_subnet_1_cidr

  vpc_a_private_subnet_1_cidr = var.vpc_a_private_subnet_1_cidr
  vpc_a_private_subnet_2_cidr = var.vpc_a_private_subnet_2_cidr
}


####################
### Module VPC B ###
####################

module "vpc_b" {
  source = "../../../tf-modules/gcp/vpc/vpc-b"
  providers = {
    google = google.singapore
  }
  depends_on = [null_resource.wait]

  vpc_b_public_subnet_1_cidr = var.vpc_b_public_subnet_1_cidr

  vpc_b_private_subnet_1_cidr = var.vpc_b_private_subnet_1_cidr
  vpc_b_private_subnet_2_cidr = var.vpc_b_private_subnet_2_cidr
}
