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

resource "aws_vpc" "vpc_a" {
  cidr_block           = var.vpc_a_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "vpc-a" }
}


#####################
### Public Subnet ###
#####################

resource "aws_subnet" "vpc_a_public_subnet" {
  count                   = var.vpc_a_public_subnet_count
  vpc_id                  = aws_vpc.vpc_a.id
  cidr_block              = cidrsubnet(cidrsubnet(var.vpc_a_cidr, 1, 0), 7, count.index)
  availability_zone       = element([var.vpc_a_availability_zone_1, var.vpc_a_availability_zone_2], count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "vpc-a-public-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "vpc_a_igw" {
  vpc_id = aws_vpc.vpc_a.id
  tags = {
    Name = "vpc-a-igw"
  }
}

resource "aws_route_table" "vpc_a_public_rt" {
  vpc_id = aws_vpc.vpc_a.id
  route {
    cidr_block = var.default_cidr
    gateway_id = aws_internet_gateway.vpc_a_igw.id
  }
}

resource "aws_route_table_association" "vpc_a_public_assoc" {
  count          = var.vpc_a_public_subnet_count
  subnet_id      = aws_subnet.vpc_a_public_subnet[count.index].id
  route_table_id = aws_route_table.vpc_a_public_rt.id
}


######################
### Private Subnet ###
######################

resource "aws_subnet" "vpc_a_private_subnet" {
  count                   = var.vpc_a_private_subnet_count
  vpc_id                  = aws_vpc.vpc_a.id
  cidr_block              = cidrsubnet(cidrsubnet(var.vpc_a_cidr, 1, 1), 7, count.index)
  availability_zone       = element([var.vpc_a_availability_zone_1, var.vpc_a_availability_zone_2], count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "vpc-a-private-subnet-${count.index}"
  }
}

resource "aws_eip" "vpc_a_nat_eip" {
  count  = length(aws_subnet.vpc_a_private_subnet)
  domain = "vpc"

  tags = {
    Name = "vpc-a-nat-eip-${count.index}"
  }
}

resource "aws_nat_gateway" "vpc_a_nat_gw" {
  count         = length(aws_subnet.vpc_a_private_subnet)
  allocation_id = aws_eip.vpc_a_nat_eip[count.index].id
  subnet_id     = aws_subnet.vpc_a_private_subnet[count.index].id
  depends_on    = [aws_internet_gateway.vpc_a_igw]

  tags = {
    Name = "vpc-a-nat-gw-${count.index}"
  }
}

resource "aws_route_table" "vpc_a_private_rt" {
  count  = length(aws_subnet.vpc_a_private_subnet)
  vpc_id = aws_vpc.vpc_a.id

  tags = {
    Name = "vpc-a-private-rt-${count.index}"
  }
}

resource "aws_route" "vpc_a_private_rt_nat_route" {
  count                  = length(aws_subnet.vpc_a_private_subnet)
  route_table_id         = aws_route_table.vpc_a_private_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.vpc_a_nat_gw[count.index].id
}

resource "aws_route_table_association" "vpc_a_private_assoc" {
  count          = length(aws_subnet.vpc_a_private_subnet)
  subnet_id      = aws_subnet.vpc_a_private_subnet[count.index].id
  route_table_id = aws_route_table.vpc_a_private_rt[count.index].id
}

#######################
### Security Groups ###
#######################

resource "aws_security_group" "vpc_a_sg_http" {
  name        = "sg_http"
  description = "Allow HTTP & HTTPS access"
  vpc_id      = aws_vpc.vpc_a.id

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

resource "aws_security_group" "vpc_a_sg_ssh" {
  name        = "sg_ssh"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.vpc_a.id

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

resource "aws_security_group" "vpc_a_sg_rdp" {
  name        = "sg_rdp"
  description = "Allow RDP access"
  vpc_id      = aws_vpc.vpc_a.id

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

resource "aws_security_group" "vpc_a_sg_rds_ec2" {
  name        = "sg_rds"
  description = "RDS allow access from EC2 instances"
  vpc_id      = aws_vpc.vpc_a.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.vpc_a_sg_ssh.id, aws_security_group.vpc_a_sg_rdp.id]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_a_dst_cidr]
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.vpc_a_sg_ssh.id, aws_security_group.vpc_a_sg_rdp.id]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_a_dst_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
