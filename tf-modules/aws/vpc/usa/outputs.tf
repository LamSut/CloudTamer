output "vpc" {
  description = "ID of the VPC"
  value       = aws_vpc.usa_vpc.id
}

output "public_subnet_1" {
  description = "ID of the public subnet"
  value       = aws_subnet.usa_public_subnet_1.id
}

output "private_subnet_1" {
  description = "ID of the private subnet"
  value       = aws_subnet.usa_private_subnet_1.id
}

output "private_subnet_2" {
  description = "ID of the private subnet"
  value       = aws_subnet.usa_private_subnet_2.id
}


##################
### SG Outputs ###
##################

output "sg_ssh" {
  description = "ID of the SSH security group"
  value       = aws_security_group.usa_sg_ssh.id
}

output "sg_rdp" {
  description = "ID of the RDP security group"
  value       = aws_security_group.usa_sg_rdp.id
}

output "sg_rds_ec2" {
  description = "ID of the RDP security group"
  value       = aws_security_group.usa_sg_rds_ec2.id
}
