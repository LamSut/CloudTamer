###########
### VPC ###
###########

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

resource "google_compute_network" "vpc_b" {
  name                    = "vpc-b"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}


#####################
### Public Subnet ###
#####################

resource "google_compute_subnetwork" "vpc_b_public_subnet_1" {
  name                     = "vpc-b-public-subnet-1"
  ip_cidr_range            = var.vpc_b_public_subnet_1_cidr
  network                  = google_compute_network.vpc_b.id
  private_ip_google_access = true
}

resource "google_compute_router" "vpc_b_router" {
  name    = "vpc-b-router"
  network = google_compute_network.vpc_b.id
}

resource "google_compute_address" "vpc_b_nat_ip" {
  name = "vpc-b-nat-ip"
}

resource "google_compute_router_nat" "vpc_b_nat_gw" {
  name                               = "vpc-b-nat-gw"
  router                             = google_compute_router.vpc_b_router.name
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.vpc_b_nat_ip.id]
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}


######################
### Private Subnet ###
######################

resource "google_compute_subnetwork" "vpc_b_private_subnet_1" {
  name                     = "vpc-b-private-subnet-1"
  ip_cidr_range            = var.vpc_b_private_subnet_1_cidr
  network                  = google_compute_network.vpc_b.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "vpc_b_private_subnet_2" {
  name                     = "vpc-b-private-subnet-2"
  ip_cidr_range            = var.vpc_b_private_subnet_2_cidr
  network                  = google_compute_network.vpc_b.id
  private_ip_google_access = true
}


######################
### Firewall Rules ###
######################

resource "google_compute_firewall" "vpc_b_fw_http" {
  name    = "vpc-b-allow-http-https"
  network = google_compute_network.vpc_b.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
}

resource "google_compute_firewall" "vpc_b_fw_ssh" {
  name    = "vpc-b-allow-ssh"
  network = google_compute_network.vpc_b.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
}

resource "google_compute_firewall" "vpc_b_fw_rdp" {
  name    = "vpc-b-allow-rdp"
  network = google_compute_network.vpc_b.name

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
}

resource "google_compute_firewall" "vpc_b_fw_rds_ec2" {
  name    = "vpc-b-allow-rds-from-ec2"
  network = google_compute_network.vpc_b.name

  allow {
    protocol = "tcp"
    ports    = ["3306", "5432"]
  }

  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
}

resource "google_compute_firewall" "vpc_b_fw_egress" {
  name    = "vpc-b-allow-egress-all"
  network = google_compute_network.vpc_b.name

  allow {
    protocol = "all"
  }

  destination_ranges = ["0.0.0.0/0"]
  direction          = "EGRESS"
}
