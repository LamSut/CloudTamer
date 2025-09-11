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

resource "aws_cloudwatch_log_group" "fe" {
  name              = "/ecs/${var.task_family}-fe"
  retention_in_days = 7
}

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


###################
### FE Services ###
###################

resource "aws_ecs_service" "fe_service" {
  name            = "${var.task_family}-fe-service"
  cluster         = var.cluster
  task_definition = aws_ecs_task_definition.fe_task.arn
  launch_type     = "FARGATE"
  desired_count   = var.fe_count

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.sg_fe]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.fe_tg_arn
    container_name   = "frontend"
    container_port   = var.fe_port
  }
}
