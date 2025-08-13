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
  region_usa       = "us-central1"
  project_id       = module.project.project_id
}

provider "google" {
  alias   = "singapore"
  project = local.project_id
  region  = local.region_singapore
}

provider "google" {
  alias   = "usa"
  project = local.project_id
  region  = local.region_usa
}

#######################
### Module Services ###
#######################

module "service" {
  source = "../../../tf-modules/gcp/service"
  providers = {
    google = google.singapore
  }
}

resource "time_sleep" "wait_service" {
  depends_on      = [module.service]
  create_duration = "15s"
}


####################
### Module VPC A ###
####################

module "vpc_a" {
  source = "../../../tf-modules/gcp/vpc/vpc-a"
  providers = {
    google = google.singapore
  }
  depends_on = [time_sleep.wait_service]

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
    google = google.usa
  }
  depends_on = [time_sleep.wait_service]

  vpc_b_public_subnet_1_cidr = var.vpc_b_public_subnet_1_cidr

  vpc_b_private_subnet_1_cidr = var.vpc_b_private_subnet_1_cidr
  vpc_b_private_subnet_2_cidr = var.vpc_b_private_subnet_2_cidr
}


##########################
### Module VPC Peering ###
##########################

resource "time_sleep" "wait_vpc" {
  depends_on = [
    module.vpc_a,
    module.vpc_b
  ]
  create_duration = "30s"
}

module "peering" {
  source = "../../../tf-modules/gcp/vpc/peering"
  providers = {
    google.a = google.singapore
    google.b = google.usa
  }
  depends_on = [time_sleep.wait_vpc]

  vpc_a_name      = module.vpc_a.vpc_a_name
  vpc_a_self_link = module.vpc_a.vpc_a_self_link
  vpc_b_name      = module.vpc_b.vpc_b_name
  vpc_b_self_link = module.vpc_b.vpc_b_self_link
}
