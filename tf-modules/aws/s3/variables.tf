variable "bucket_name" {}
variable "bucket_policy" {}
variable "tags" {}

variable "asset_path" {}
variable "mime_types" {}

variable "index_suffix" {
  type    = string
  default = "index.html"
}

variable "error_file" {
  type    = string
  default = "error.html"
}

data "aws_region" "current" {}
