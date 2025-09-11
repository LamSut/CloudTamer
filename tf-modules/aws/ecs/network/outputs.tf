output "cluster" {
  description = "ECS Cluster ID"
  value       = aws_ecs_cluster.cluster.id
}

output "sg_fe" {
  description = "Security Group for the ECS FE service"
  value       = aws_security_group.vpc_sg_ecs_fe.id
}

output "sg_be" {
  description = "Security Group for the ECS BE service"
  value       = aws_security_group.vpc_sg_ecs_be.id
}
