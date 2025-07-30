variable "bucket_policy" {
  type    = string
  default = "./env/conf/s3_static_policy.json"
}

variable "asset_path" {
  type    = string
  default = "./env/conf/limweb"
}
