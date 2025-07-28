output "ec2_public_ips" {
  value = {
    amazon  = module.ec2.amazon_public_ips
    ubuntu  = module.ec2.ubuntu_public_ips
    windows = module.ec2.windows_public_ips
  }
}
