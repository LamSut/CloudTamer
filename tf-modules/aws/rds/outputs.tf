output "mysql_endpoint" {
  value = split(":", aws_db_instance.mysql.endpoint)[0]
}
