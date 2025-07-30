terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}


########################
### RDS Subnet Group ###
########################

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = [var.private_subnet_1, var.private_subnet_2]
}


######################
### RDS Parameters ###
######################

resource "aws_db_parameter_group" "rds_param_group" {
  name        = "${var.family}-param-group"
  family      = var.family
  description = "Parameter group for ${var.engine}"

  dynamic "parameter" {
    for_each = var.engine == "mysql" ? [
      {
        name  = "slow_query_log"
        value = "1"
      },
      {
        name  = "long_query_time"
        value = "1"
      },
      {
        name  = "log_output"
        value = "FILE"
      },
      {
        name  = "log_queries_not_using_indexes"
        value = "0"
      }
      ] : var.engine == "postgres" ? [
      {
        name  = "log_min_duration_statement"
        value = "1000"
      },
      {
        name  = "log_statement"
        value = "none"
      }
    ] : []

    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}



resource "aws_db_instance" "rds_instance" {
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [var.sg_rds_ec2]
  parameter_group_name    = aws_db_parameter_group.rds_param_group.name
  skip_final_snapshot     = true # No final snapshot before deletion
  publicly_accessible     = false
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
}

# resource "aws_db_instance" "mysql" {
#   allocated_storage       = 10
#   db_name                 = "limdb"
#   engine                  = "mysql"
#   engine_version          = "8.0"
#   instance_class          = "db.t3.micro"
#   username                = "limtruong"
#   password                = "limkhietngoingoi"
#   db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
#   vpc_security_group_ids  = [var.sg_rds_ec2]
#   parameter_group_name    = aws_db_parameter_group.mysql_params.name
#   skip_final_snapshot     = true # No final snapshot before deletion
#   publicly_accessible     = false
#   backup_retention_period = 7 # Backup every week
#   backup_window           = "18:00-19:00"
# }


