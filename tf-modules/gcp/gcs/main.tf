#############################
### GCS Static Website #####
#############################

resource "google_storage_bucket" "static_website" {
  name     = var.bucket_name
  location = var.bucket_location
  project  = var.project

  force_destroy               = true // Allows deletion of bucket with objects (for dev environment)
  uniform_bucket_level_access = true
  website {
    main_page_suffix = var.index_suffix
    not_found_page   = var.error_file
  }
  labels = var.labels
}

resource "google_storage_bucket_iam_binding" "public_access" {
  bucket = google_storage_bucket.static_website.name
  role   = "roles/storage.objectViewer"
  members = [
    "allUsers",
  ]
}

resource "google_storage_bucket_object" "static_website_assets" {
  for_each     = fileset(var.asset_path, "**/*")
  name         = each.value
  bucket       = google_storage_bucket.static_website.name
  source       = "${var.asset_path}/${each.value}"
  content_type = lookup(var.mime_types, regex("[^.]*$", each.value), "application/octet-stream")
}
