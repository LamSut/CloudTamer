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
  tags                 = { Name = "vpc_b" }
}


#####################
### Public Subnet ###
#####################

resource "aws_subnet" "vpc_b_public_subnet_1" {
  vpc_id                  = aws_vpc.vpc_b.id
  cidr_block              = var.vpc_b_public_subnet_1_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.vpc_b_availability_zone_1
}

resource "aws_internet_gateway" "vpc_b_igw" {
  vpc_id = aws_vpc.vpc_b.id
}

resource "aws_route_table" "vpc_b_public_rt" {
  vpc_id = aws_vpc.vpc_b.id
  route {
    cidr_block = var.default_cidr
    gateway_id = aws_internet_gateway.vpc_b_igw.id
  }
}

resource "aws_route_table_association" "vpc_b_public_assoc" {
  subnet_id      = aws_subnet.vpc_b_public_subnet_1.id
  route_table_id = aws_route_table.vpc_b_public_rt.id
}


######################
### Private Subnet ###
######################

resource "aws_subnet" "vpc_b_private_subnet_1" {
  vpc_id                  = aws_vpc.vpc_b.id
  cidr_block              = var.vpc_b_private_subnet_1_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.vpc_b_availability_zone_1
}

resource "aws_subnet" "vpc_b_private_subnet_2" {
  vpc_id                  = aws_vpc.vpc_b.id
  cidr_block              = var.vpc_b_private_subnet_2_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.vpc_b_availability_zone_2
}

resource "aws_eip" "vpc_b_nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "vpc_b_nat_gw" {
  allocation_id = aws_eip.vpc_b_nat_eip.id
  subnet_id     = aws_subnet.vpc_b_public_subnet_1.id
  depends_on    = [aws_internet_gateway.vpc_b_igw]
}

resource "aws_route_table" "vpc_b_private_rt" {
  vpc_id = aws_vpc.vpc_b.id
}

resource "aws_route" "vpc_b_private_rt_nat_route" {
  route_table_id         = aws_route_table.vpc_b_private_rt.id
  destination_cidr_block = var.default_cidr
  nat_gateway_id         = aws_nat_gateway.vpc_b_nat_gw.id
}

resource "aws_route_table_association" "vpc_b_private_assoc_1" {
  subnet_id      = aws_subnet.vpc_b_private_subnet_1.id
  route_table_id = aws_route_table.vpc_b_private_rt.id
}

resource "aws_route_table_association" "vpc_b_private_assoc_2" {
  subnet_id      = aws_subnet.vpc_b_private_subnet_2.id
  route_table_id = aws_route_table.vpc_b_private_rt.id
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
