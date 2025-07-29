terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.a, aws.b]
    }
  }
}


##############################
### Amazon Linux Instances ###
##############################

resource "aws_instance" "ec2_amazon" {
  provider      = aws.a
  count         = var.amazon_count
  ami           = data.aws_ami.ami_amazon_2023.id
  instance_type = var.instance_type
  key_name      = var.key_name
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  subnet_id              = var.public_subnet_a1
  vpc_security_group_ids = [var.sg_ssh_a]

  tags = {
    Name = "Amazon Linux ${count.index}"
  }
}

resource "aws_eip" "eip_amazon" {
  provider = aws.a
  count    = length(aws_instance.ec2_amazon)
  instance = aws_instance.ec2_amazon[count.index].id

  depends_on = [aws_instance.ec2_amazon]
}


########################
### Ubuntu Instances ###
########################

resource "aws_instance" "ec2_ubuntu" {
  provider      = aws.b
  count         = var.ubuntu_count
  ami           = data.aws_ami.ami_ubuntu_2404.id
  instance_type = var.instance_type
  key_name      = var.key_name
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  subnet_id              = var.public_subnet_b1
  vpc_security_group_ids = [var.sg_ssh_b]

  tags = {
    Name = "Ubuntu ${count.index}"
  }
}

resource "aws_eip" "eip_ubuntu" {
  provider = aws.b
  count    = length(aws_instance.ec2_ubuntu)
  instance = aws_instance.ec2_ubuntu[count.index].id

  depends_on = [aws_instance.ec2_ubuntu]
}


#########################
### Windows Instances ###
#########################

resource "aws_instance" "ec2_windows" {
  provider      = aws.a
  count         = var.windows_count
  ami           = data.aws_ami.ami_windows_2025.id
  instance_type = var.instance_type
  key_name      = var.key_name
  root_block_device {
    volume_size = 35
    volume_type = "gp3"
  }

  subnet_id              = var.public_subnet_a1
  vpc_security_group_ids = [var.sg_rdp_a]

  tags = {
    Name = "Windows ${count.index}"
  }
}

resource "aws_eip" "eip_windows" {
  provider = aws.a
  count    = length(aws_instance.ec2_windows)
  instance = aws_instance.ec2_windows[count.index].id

  depends_on = [aws_instance.ec2_windows]
}


################
### EC2 AMIs ###
################

data "aws_ami" "ami_amazon_2023" {
  provider    = aws.a
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ami_ubuntu_2404" {
  provider    = aws.b
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ami_windows_2025" {
  provider    = aws.a
  most_recent = true
  owners      = ["801119661308"]

  filter {
    name   = "name"
    values = ["Windows_Server-2025-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
