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

output "mysql_connect_cmd" {
  description = "MySQL CLI connection string"
  value       = "mysql -h ${module.rds.mysql_endpoint} -u limtruong -plimkhietngoingoi limdb"
}
