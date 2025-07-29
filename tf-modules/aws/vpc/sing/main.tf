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

resource "aws_vpc" "sing_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "sing_vpc" }
}


#####################
### Public Subnet ###
#####################

resource "aws_subnet" "sing_public_subnet_1" {
  vpc_id                  = aws_vpc.sing_vpc.id
  cidr_block              = var.public_subnet_1_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone_1
}

resource "aws_internet_gateway" "sing_igw" {
  vpc_id = aws_vpc.sing_vpc.id
}

resource "aws_route_table" "sing_public_rt" {
  vpc_id = aws_vpc.sing_vpc.id
  route {
    cidr_block = var.default_cidr
    gateway_id = aws_internet_gateway.sing_igw.id
  }
}

resource "aws_route_table_association" "sing_public_assoc" {
  subnet_id      = aws_subnet.sing_public_subnet_1.id
  route_table_id = aws_route_table.sing_public_rt.id
}


######################
### Private Subnet ###
######################

resource "aws_subnet" "sing_private_subnet_1" {
  vpc_id                  = aws_vpc.sing_vpc.id
  cidr_block              = var.private_subnet_1_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone_1
}

resource "aws_subnet" "sing_private_subnet_2" {
  vpc_id                  = aws_vpc.sing_vpc.id
  cidr_block              = var.private_subnet_2_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone_2
}


#######################
### Security Groups ###
#######################

resource "aws_security_group" "sing_sg_ssh" {
  name        = "sg_ssh"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.sing_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

resource "aws_security_group" "sing_sg_rdp" {
  name        = "sg_rdp"
  description = "Allow RDP access"
  vpc_id      = aws_vpc.sing_vpc.id

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_security_group" "sing_sg_rds_ec2" {
  name        = "sg_rds"
  description = "RDS allow MySQL from EC2 only"
  vpc_id      = aws_vpc.sing_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.sing_sg_ssh.id, aws_security_group.sing_sg_rdp.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
