variable "static_policy" {
  type    = string
  default = "./env/dev/s3_static_policy.json"
}

variable "asset_path" {
  type    = string
  default = "./env/dev/limweb"
}
