terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}


###################
### ECS Cluster ###
###################

resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}


##################
### Networking ###
##################

resource "aws_security_group" "vpc_sg_ecs_fe" {
  name        = "sg_ecs_fe"
  description = "ECS FE allow access from ALB"
  vpc_id      = var.vpc

  ingress {
    from_port       = var.fe_port
    to_port         = var.fe_port
    protocol        = "tcp"
    security_groups = [var.sg_http]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "vpc_sg_ecs_be" {
  name        = "sg_ecs_be"
  description = "ECS BE allow access from ALB"
  vpc_id      = var.vpc

  ingress {
    from_port       = var.be_port
    to_port         = var.be_port
    protocol        = "tcp"
    security_groups = [aws_security_group.vpc_sg_ecs_fe.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
