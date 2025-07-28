########################
### RDS Subnet Group ###
########################

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = [var.private_subnet_1, var.private_subnet_2]
}


#################
### MySQL RDS ###
#################

resource "aws_db_parameter_group" "mysql_params" {
  name   = "mysql-slow-log"
  family = "mysql8.0"

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "long_query_time"
    value = "1"
  }

  parameter {
    name  = "log_output"
    value = "FILE" // Options: FILE or TABLE
  }

  parameter {
    name  = "log_queries_not_using_indexes"
    value = "0" // Set 1 to log queries that do not use indexes
  }
}

resource "aws_db_instance" "mysql" {
  allocated_storage       = 10
  db_name                 = "limdb"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                = "limtruong"
  password                = "limkhietngoingoi"
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [var.sg_rds_ec2]
  parameter_group_name    = aws_db_parameter_group.mysql_params.name
  skip_final_snapshot     = true # No final snapshot before deletion
  publicly_accessible     = false
  backup_retention_period = 7 # Backup every week
  backup_window           = "18:00-19:00"
}

output "mysql_endpoint" {
  value = split(":", aws_db_instance.mysql.endpoint)[0]
}


