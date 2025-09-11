terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}


###########################
### ECS Task Definition ###
###########################

resource "aws_cloudwatch_log_group" "be" {
  name              = "/ecs/${var.task_family}-be"
  retention_in_days = 7
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


###################
### BE Services ###
###################

resource "aws_service_discovery_private_dns_namespace" "this" {
  name        = "${var.task_family}.local"
  description = "Private DNS namespace for ECS services"
  vpc         = var.vpc
}

resource "aws_service_discovery_service" "be" {
  name = "backend"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.this.id

    dns_records {
      type = "A"
      ttl  = 10
    }

    routing_policy = "MULTIVALUE"
  }
}

resource "aws_ecs_service" "be_service" {
  name            = "${var.task_family}-be-service"
  cluster         = var.cluster
  task_definition = aws_ecs_task_definition.be_task.arn
  launch_type     = "FARGATE"
  desired_count   = var.be_count

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.sg_be]
    assign_public_ip = true
  }

  service_registries {
    registry_arn = aws_service_discovery_service.be.arn
  }
}


