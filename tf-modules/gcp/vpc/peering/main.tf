terraform {
  required_providers {
    google = {
      source                = "hashicorp/google"
      configuration_aliases = [google.a, google.b]
    }
  }
}

resource "google_compute_network_peering" "peer_a_to_b" {
  provider     = google.a
  name         = "peer-a-to-b"
  network      = var.vpc_a_self_link
  peer_network = var.vpc_b_self_link
}

resource "google_compute_network_peering" "peer_b_to_a" {
  provider     = google.b
  name         = "peer-b-to-a"
  network      = var.vpc_b_self_link
  peer_network = var.vpc_a_self_link
  depends_on   = [google_compute_network_peering.peer_a_to_b]
}

resource "google_compute_network_peering_routes_config" "peer_a_to_b" {
  provider             = google.a
  peering              = google_compute_network_peering.peer_a_to_b.name
  network              = var.vpc_a_name
  import_custom_routes = true
  export_custom_routes = true
  depends_on           = [google_compute_network_peering.peer_b_to_a]
}

resource "google_compute_network_peering_routes_config" "peer_b_to_a" {
  provider             = google.b
  peering              = google_compute_network_peering.peer_b_to_a.name
  network              = var.vpc_b_name
  import_custom_routes = true
  export_custom_routes = true
  depends_on           = [google_compute_network_peering.peer_a_to_b]
}

