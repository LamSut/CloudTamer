variable "bucket_name" {
  type    = string
  default = "lim-static-website"
}

variable "bucket_policy" {
  type    = string
  default = "./env/conf/s3_static_website_policy.json"
}

variable "asset_path" {
  type    = string
  default = "./env/conf/limweb"
}

variable "index_suffix" {
  type    = string
  default = "index.html"
}

variable "error_file" {
  type    = string
  default = "error.html"
}

locals {
  tags = {
    Environment = "dev"
    Project     = "terraform-static-site"
  }

  mime_types = {
    html  = "text/html"
    css   = "text/css"
    ttf   = "font/ttf"
    woff  = "font/woff"
    woff2 = "font/woff2"
    js    = "application/javascript"
    map   = "application/javascript"
    json  = "application/json"
    jpg   = "image/jpeg"
    png   = "image/png"
    svg   = "image/svg+xml"
    eot   = "application/vnd.ms-fontobject"
  }
}
