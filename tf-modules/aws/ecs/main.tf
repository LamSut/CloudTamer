terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
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


###################
### ECS Cluster ###
###################

resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}


###########################
### ECS Task Definition ###
###########################

resource "aws_ecs_task_definition" "fe_task" {
  family                   = "${var.task_family}-fe"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  container_definitions    = var.fe_container_definitions
}

resource "aws_ecs_task_definition" "be_task" {
  family                   = "${var.task_family}-be"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  container_definitions    = var.be_container_definitions
}


####################
### ECS Services ###
####################

resource "aws_ecs_service" "fe_service" {
  name            = "${var.task_family}-fe-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.fe_task.arn
  launch_type     = "FARGATE"
  desired_count   = var.fe_count

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.vpc_sg_ecs_fe.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.fe_tg_arn
    container_name   = "frontend"
    container_port   = var.fe_port
  }
}

resource "aws_ecs_service" "be_service" {
  name            = "${var.task_family}-be-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.be_task.arn
  launch_type     = "FARGATE"
  desired_count   = var.be_count

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.vpc_sg_ecs_be.id]
    assign_public_ip = true
  }
}

