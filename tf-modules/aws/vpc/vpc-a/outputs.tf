#######################
### Network Outputs ###
#######################

output "vpc" {
  description = "ID of the VPC"
  value       = aws_vpc.vpc_a.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.vpc_a.cidr_block
}

output "public_subnet_1" {
  description = "ID of the public subnet"
  value       = aws_subnet.vpc_a_public_subnet_1.id
}

output "private_subnet_1" {
  description = "ID of the private subnet"
  value       = aws_subnet.vpc_a_private_subnet_1.id
}

output "private_subnet_2" {
  description = "ID of the private subnet"
  value       = aws_subnet.vpc_a_private_subnet_2.id
}

output "public_rt" {
  description = "ID of the public route table"
  value       = aws_route_table.vpc_a_public_rt.id
}

output "private_rt" {
  description = "ID of the private route table"
  value       = aws_route_table.vpc_a_private_rt.id
}


##################
### SG Outputs ###
##################

output "sg_ssh" {
  description = "ID of the SSH security group"
  value       = aws_security_group.vpc_a_sg_ssh.id
}

output "sg_rdp" {
  description = "ID of the RDP security group"
  value       = aws_security_group.vpc_a_sg_rdp.id
}

output "sg_rds_ec2" {
  description = "ID of the RDP security group"
  value       = aws_security_group.vpc_a_sg_rds_ec2.id
}
