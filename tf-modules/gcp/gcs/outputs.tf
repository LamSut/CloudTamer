output "website_url" {
  value = "https://storage.googleapis.com/${google_storage_bucket.static_website.name}/index.html"
}
