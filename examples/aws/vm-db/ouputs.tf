#########################
### Terraform Outputs ###
#########################

output "ec2_public_ips" {
  value = {
    amazon  = module.ec2.amazon_public_ips
    ubuntu  = module.ec2.ubuntu_public_ips
    windows = module.ec2.windows_public_ips
  }
}

output "rds_connect_cmd" {
  description = "Command to connect to RDS (you will be prompted for the password)"
  value = (
    var.engine == "postgres" ?
    "psql -h ${module.rds.rds_host} -U ${var.db_username} -d ${var.db_name}" :
    "mysql -h ${module.rds.rds_host} -u ${var.db_username} -p ${var.db_name}"
  )
}

