##################################
### Google Compute VM Instances ###
##################################

terraform {
  required_providers {
    google = {
      source                = "hashicorp/google"
      configuration_aliases = [google.a, google.b]
    }
  }
}


##################
### Windows VM ###
##################

# resource "google_compute_address" "win_ip" {
#   provider = google.a
#   count = var.win_count
#   name  = "win-ip-${count.index + 1}"
# }

# resource "google_compute_instance" "win_vm" {
#   provider     = google.a
#   count        = var.win_count
#   name         = "win-vm-${count.index + 1}"
#   machine_type = var.win_machine_type
#   zone         = var.zone_a1

#   boot_disk {
#     initialize_params {
#       image = var.win_image
#     }
#   }

#   network_interface {
#     subnetwork = var.public_subnet_a1
#     access_config {
#       nat_ip = google_compute_address.win_ip[count.index].address
#     }
#   }

#   tags = ["windows", "public"]
# }


################
### RHEL VM  ###
################

resource "google_compute_address" "rhel_ip" {
  provider = google.b
  count    = var.rhel_count
  name     = "rhel-ip-${count.index + 1}"
}

resource "google_compute_instance" "rhel_vm" {
  provider     = google.b
  count        = var.rhel_count
  name         = "rhel-vm-${count.index + 1}"
  machine_type = var.rhel_machine_type
  zone         = var.zone_b1

  boot_disk {
    initialize_params {
      image = var.rhel_image
    }
  }

  network_interface {
    subnetwork = var.public_subnet_b1
    access_config {
      nat_ip = google_compute_address.rhel_ip[count.index].address
    }
  }

  tags = ["rhel", "public"]
}


##################
### Debian VM  ###
##################

resource "google_compute_address" "debian_ip" {
  provider = google.b
  count    = var.debian_count
  name     = "debian-ip-${count.index + 1}"
}

resource "google_compute_instance" "debian_vm" {
  provider     = google.b
  count        = var.debian_count
  name         = "debian-vm-${count.index + 1}"
  machine_type = var.debian_machine_type
  zone         = var.zone_b1

  boot_disk {
    initialize_params {
      image = var.debian_image
    }
  }

  network_interface {
    subnetwork = var.public_subnet_b1
    access_config {
      nat_ip = google_compute_address.debian_ip[count.index].address
    }
  }

  tags = ["debian", "public"]
}

