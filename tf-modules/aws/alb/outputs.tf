output "fe_tg_arn" {
  description = "ARN of the frontend target group"
  value       = aws_lb_target_group.fe_tg.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.main.dns_name
}
