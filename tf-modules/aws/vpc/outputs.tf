output "vpc" {
  description = "ID of the VPC"
  value       = aws_vpc.limtruong_vpc.id
}

output "public_subnet_1" {
  description = "ID of the public subnet"
  value       = aws_subnet.public_subnet_1.id
}

output "private_subnet_1" {
  description = "ID of the private subnet"
  value       = aws_subnet.private_subnet_1.id
}

output "private_subnet_2" {
  description = "ID of the private subnet"
  value       = aws_subnet.private_subnet_2.id
}

output "sg_ssh" {
  description = "ID of the SSH security group"
  value       = aws_security_group.sg_ssh.id
}

output "sg_rdp" {
  description = "ID of the RDP security group"
  value       = aws_security_group.sg_rdp.id
}

output "sg_rds_ec2" {
  description = "ID of the RDP security group"
  value       = aws_security_group.sg_rds_ec2.id
}
