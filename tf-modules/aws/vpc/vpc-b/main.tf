###########
### VPC ###
###########

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_vpc" "vpc_b" {
  cidr_block           = var.vpc_b_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "vpc-b" }
}

#####################
### Public Subnet ###
#####################

resource "aws_subnet" "vpc_b_public_subnet" {
  for_each = {
    "az1" = { az = var.vpc_b_availability_zone_1, idx = 0 }
    "az2" = { az = var.vpc_b_availability_zone_2, idx = 1 }
  }

  vpc_id                  = aws_vpc.vpc_b.id
  cidr_block              = cidrsubnet(cidrsubnet(var.vpc_b_cidr, 1, 0), 7, each.value.idx)
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = "vpc-b-public-subnet-${each.key}"
  }
}

resource "aws_internet_gateway" "vpc_b_igw" {
  vpc_id = aws_vpc.vpc_b.id
  tags   = { Name = "vpc-b-igw" }
}

resource "aws_route_table" "vpc_b_public_rt" {
  vpc_id = aws_vpc.vpc_b.id

  route {
    cidr_block = var.default_cidr
    gateway_id = aws_internet_gateway.vpc_b_igw.id
  }
}

resource "aws_route_table_association" "vpc_b_public_assoc" {
  for_each       = aws_subnet.vpc_b_public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.vpc_b_public_rt.id
}

######################
### Private Subnet ###
######################

resource "aws_subnet" "vpc_b_private_subnet" {
  for_each = {
    "az1" = { az = var.vpc_b_availability_zone_1, idx = 0 }
    "az2" = { az = var.vpc_b_availability_zone_2, idx = 1 }
  }

  vpc_id                  = aws_vpc.vpc_b.id
  cidr_block              = cidrsubnet(cidrsubnet(var.vpc_b_cidr, 1, 1), 7, each.value.idx)
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = {
    Name = "vpc-b-private-subnet-${each.key}"
  }
}

resource "aws_eip" "vpc_b_nat_eip" {
  for_each = aws_subnet.vpc_b_public_subnet
  domain   = "vpc"

  tags = {
    Name = "vpc-b-nat-eip-${each.key}"
  }
}

resource "aws_nat_gateway" "vpc_b_nat_gw" {
  for_each      = aws_eip.vpc_b_nat_eip
  allocation_id = each.value.id
  subnet_id     = aws_subnet.vpc_b_public_subnet[each.key].id
  depends_on    = [aws_internet_gateway.vpc_b_igw]

  tags = {
    Name = "vpc-b-nat-gw-${each.key}"
  }
}

resource "aws_route_table" "vpc_b_private_rt" {
  for_each = aws_nat_gateway.vpc_b_nat_gw
  vpc_id   = aws_vpc.vpc_b.id

  tags = {
    Name = "vpc-b-private-rt-${each.key}"
  }
}

resource "aws_route" "vpc_b_private_rt_nat_route" {
  for_each               = aws_route_table.vpc_b_private_rt
  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.vpc_b_nat_gw[each.key].id
}

resource "aws_route_table_association" "vpc_b_private_assoc" {
  for_each       = aws_subnet.vpc_b_private_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.vpc_b_private_rt[each.key].id
}

#######################
### Security Groups ###
#######################

resource "aws_security_group" "vpc_b_sg_http" {
  name        = "sg_http"
  description = "Allow HTTP & HTTPS access"
  vpc_id      = aws_vpc.vpc_b.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "vpc_b_sg_ssh" {
  name        = "sg_ssh"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.vpc_b.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "vpc_b_sg_rdp" {
  name        = "sg_rdp"
  description = "Allow RDP access"
  vpc_id      = aws_vpc.vpc_b.id

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "vpc_b_sg_rds_ec2" {
  name        = "sg_rds"
  description = "RDS allow access from EC2 instances"
  vpc_id      = aws_vpc.vpc_b.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.vpc_b_sg_ssh.id, aws_security_group.vpc_b_sg_rdp.id]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_b_dst_cidr]
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.vpc_b_sg_ssh.id, aws_security_group.vpc_b_sg_rdp.id]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_b_dst_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
