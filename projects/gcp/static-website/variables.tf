################################################
### GCP Project Static Website Configuration ###
################################################

variable "project" {
  description = "GCP project ID"
  type        = string
  default     = "static-website-468004"
}


############################
### Bucket Configuration ###
############################

variable "bucket_name" {
  description = "Name of the GCS bucket"
  type        = string
  default     = "lim-static-website"
}

variable "bucket_location" {
  description = "GCS bucket location"
  type        = string
  default     = "Asia"
}


####################################
### Static Website Configuration ###
####################################

variable "asset_path" {
  description = "Path to the static assets on local machine"
  type        = string
  default     = "../../../shared/static-website"
}

variable "index_suffix" {
  description = "Main index file for the website"
  type        = string
  default     = "index.html"
}

variable "error_file" {
  description = "Error page for the website"
  type        = string
  default     = "error.html"
}


###########################################
### MIME Types and Labels Configuration ###
###########################################

variable "mime_types" {
  description = "Mapping of file extensions to MIME types"
  type        = map(string)
  default = {
    html = "text/html"
    css  = "text/css"
    js   = "application/javascript"
    png  = "image/png"
    jpg  = "image/jpeg"
    jpeg = "image/jpeg"
    svg  = "image/svg+xml"
    json = "application/json"
    txt  = "text/plain"
  }
}

variable "labels" {
  description = "Labels to apply to GCS bucket"
  type        = map(string)
  default     = {}
}
