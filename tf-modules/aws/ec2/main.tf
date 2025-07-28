##############################
### Amazon Linux Instances ###
##############################

resource "aws_instance" "ec2_amazon" {
  count         = 0
  ami           = data.aws_ami.ami_amazon_2023.id
  instance_type = var.instance_small
  key_name      = var.key_name
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  subnet_id              = var.public_subnet_1
  vpc_security_group_ids = [var.sg_ssh]

  tags = {
    Name = "Amazon Linux ${count.index}"
  }
}

resource "aws_eip" "eip_amazon" {
  count    = length(aws_instance.ec2_amazon)
  instance = aws_instance.ec2_amazon[count.index].id

  depends_on = [aws_instance.ec2_amazon]
}


########################
### Ubuntu Instances ###
########################

resource "aws_instance" "ec2_ubuntu" {
  count         = 0
  ami           = data.aws_ami.ami_ubuntu_2404.id
  instance_type = var.instance_small
  key_name      = var.key_name
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  subnet_id              = var.public_subnet_1
  vpc_security_group_ids = [var.sg_ssh]

  tags = {
    Name = "Ubuntu ${count.index}"
  }
}

resource "aws_eip" "eip_ubuntu" {
  count    = length(aws_instance.ec2_ubuntu)
  instance = aws_instance.ec2_ubuntu[count.index].id

  depends_on = [aws_instance.ec2_ubuntu]
}


#########################
### Windows Instances ###
#########################

resource "aws_instance" "ec2_windows" {
  count         = 0
  ami           = data.aws_ami.ami_windows_2025.id
  instance_type = var.instance_small
  key_name      = var.key_name
  root_block_device {
    volume_size = 35
    volume_type = "gp3"
  }

  subnet_id              = var.public_subnet_1
  vpc_security_group_ids = [var.sg_rdp]

  tags = {
    Name = "Windows ${count.index}"
  }
}

resource "aws_eip" "eip_windows" {
  count    = length(aws_instance.ec2_windows)
  instance = aws_instance.ec2_windows[count.index].id

  depends_on = [aws_instance.ec2_windows]
}
