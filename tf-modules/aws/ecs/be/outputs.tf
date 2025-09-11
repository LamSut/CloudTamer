output "be_service_dns" {
  description = "Internal DNS endpoint for the BE service"
  value       = "http://backend.${var.task_family}.local:${var.be_port}"
}
