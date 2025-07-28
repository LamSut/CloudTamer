##################
### EC2 Amazon ###
##################

output "amazon_ids" {
  description = "IDs of Amazon Linux instances"
  value       = aws_instance.ec2_amazon[*].id
}

output "amazon_public_ips" {
  description = "Elastic IPs of Amazon Linux instances"
  value       = aws_eip.eip_amazon[*].public_ip
}

output "amazon_names" {
  description = "Tag 'Name' of Amazon Linux instances"
  value       = [for inst in aws_instance.ec2_amazon : inst.tags["Name"]]
}


##################
### EC2 Ubuntu ###
##################

output "ubuntu_ids" {
  description = "IDs of Ubuntu instances"
  value       = aws_instance.ec2_ubuntu[*].id
}

output "ubuntu_public_ips" {
  description = "Elastic IPs of Ubuntu instances"
  value       = aws_eip.eip_ubuntu[*].public_ip
}

output "ubuntu_names" {
  description = "Tag 'Name' of Ubuntu instances"
  value       = [for inst in aws_instance.ec2_ubuntu : inst.tags["Name"]]
}


######################
### Ec2Windows EC2 ###
######################

output "windows_ids" {
  description = "IDs of Windows instances"
  value       = aws_instance.ec2_windows[*].id
}

output "windows_public_ips" {
  description = "Elastic IPs of Windows instances"
  value       = aws_eip.eip_windows[*].public_ip
}

output "windows_names" {
  description = "Tag 'Name' of Windows instances"
  value       = [for inst in aws_instance.ec2_windows : inst.tags["Name"]]
}
