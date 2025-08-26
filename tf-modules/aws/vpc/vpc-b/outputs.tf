#######################
### Network Outputs ###
#######################

output "vpc" {
  description = "ID of the VPC"
  value       = aws_vpc.vpc_b.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.vpc_b.cidr_block
}

output "public_subnet" {
  description = "IDs of the public subnets"
  value       = aws_subnet.vpc_b_public_subnet[*].id
}

output "private_subnet" {
  description = "IDs of the private subnets"
  value       = aws_subnet.vpc_b_private_subnet[*].id
}

output "public_rt" {
  description = "ID of the public route table"
  value       = aws_route_table.vpc_b_public_rt.id
}

output "private_rt" {
  description = "ID of the private route table"
  value       = aws_route_table.vpc_b_private_rt[*].id
}


##################
### SG Outputs ###
##################

output "sg_http" {
  description = "ID of the HTTP security group"
  value       = aws_security_group.vpc_b_sg_http.id
}

output "sg_ssh" {
  description = "ID of the SSH security group"
  value       = aws_security_group.vpc_b_sg_ssh.id
}

output "sg_rdp" {
  description = "ID of the RDP security group"
  value       = aws_security_group.vpc_b_sg_rdp.id
}

output "sg_rds_ec2" {
  description = "ID of the RDP security group"
  value       = aws_security_group.vpc_b_sg_rds_ec2.id
}
