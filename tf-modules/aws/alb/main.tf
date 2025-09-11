terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}


#################
### ALB Main  ###
#################

resource "aws_lb" "main" {
  name               = "${var.cluster_name}-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [var.sg_http]
}

#####################
### Target Groups ###
#####################

resource "aws_lb_target_group" "fe_tg" {
  name        = "${var.cluster_name}-fe-tg"
  port        = var.fe_port
  protocol    = "HTTP"
  vpc_id      = var.vpc
  target_type = "ip"
}


##################
### Listeners  ###
##################

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fe_tg.arn
  }
}
