#########################
### VPC Configuration ###
#########################

variable "peer_region" {
  type    = string
  default = "us-east-1"
}


#########################
### EC2 Configuration ###
#########################

variable "amazon_count" {
  type    = number
  default = 1
}

variable "ubuntu_count" {
  type    = number
  default = 1
}

variable "windows_count" {
  type    = number
  default = 0
}

variable "key_name" {
  type    = string
  default = "limtruong-pair"
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}


#########################
### RDS Configuration ###
#########################

variable "family" {
  type    = string
  default = "postgres17"
}

variable "engine" {
  default = "postgres"
}

variable "engine_version" {
  default = "17.5"
}

variable "instance_class" {
  default = "db.t3.micro"
}

variable "allocated_storage" {
  default = 10
}

variable "db_name" {
  default = "limdb"
}

variable "db_username" {
  default = "limtruong"
}

variable "db_password" {
  sensitive = true
}

variable "backup_retention_period" {
  default = 7
}

variable "backup_window" {
  default = "18:00-19:00"
}
