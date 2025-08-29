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
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = true
  }
}

resource "aws_ecs_service" "be_service" {
  name            = "${var.task_family}-be-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.be_task.arn
  launch_type     = "FARGATE"
  desired_count   = var.be_count

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = true
  }
}
