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

resource "google_compute_network" "vpc_a" {
  name                    = "vpc-a"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}


#####################
### Public Subnet ###
#####################

resource "google_compute_subnetwork" "vpc_a_public_subnet_1" {
  name                     = "vpc-a-public-subnet-1"
  ip_cidr_range            = var.vpc_a_public_subnet_1_cidr
  network                  = google_compute_network.vpc_a.id
  private_ip_google_access = true
}


resource "google_compute_router" "vpc_a_router" {
  name    = "vpc-a-router"
  network = google_compute_network.vpc_a.id
}

resource "google_compute_address" "vpc_a_nat_ip" {
  name = "vpc-a-nat-ip"
}

resource "google_compute_router_nat" "vpc_a_nat_gw" {
  name                               = "vpc-a-nat-gw"
  router                             = google_compute_router.vpc_a_router.name
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.vpc_a_nat_ip.id]
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}


######################
### Private Subnet ###
######################

resource "google_compute_subnetwork" "vpc_a_private_subnet_1" {
  name                     = "vpc-a-private-subnet-1"
  ip_cidr_range            = var.vpc_a_private_subnet_1_cidr
  network                  = google_compute_network.vpc_a.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "vpc_a_private_subnet_2" {
  name                     = "vpc-a-private-subnet-2"
  ip_cidr_range            = var.vpc_a_private_subnet_2_cidr
  network                  = google_compute_network.vpc_a.id
  private_ip_google_access = true
}


######################
### Firewall Rules ###
######################

resource "google_compute_firewall" "vpc_a_fw_http" {
  name    = "allow-http-https"
  network = google_compute_network.vpc_a.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
}

resource "google_compute_firewall" "vpc_a_fw_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_a.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
}

resource "google_compute_firewall" "vpc_a_fw_rdp" {
  name    = "allow-rdp"
  network = google_compute_network.vpc_a.name

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
}

resource "google_compute_firewall" "vpc_a_fw_rds_ec2" {
  name    = "allow-rds-from-ec2"
  network = google_compute_network.vpc_a.name

  allow {
    protocol = "tcp"
    ports    = ["3306", "5432"]
  }

  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
}

resource "google_compute_firewall" "vpc_a_fw_egress" {
  name    = "allow-egress-all"
  network = google_compute_network.vpc_a.name

  allow {
    protocol = "all"
  }

  destination_ranges = ["0.0.0.0/0"]
  direction          = "EGRESS"
}
