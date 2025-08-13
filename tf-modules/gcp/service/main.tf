terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

resource "google_project_service" "compute" {
  service            = "compute.googleapis.com"
  disable_on_destroy = true
}
