###############
### Outputs ###
###############

output "vpc_peering_id" {
  description = "The ID of the VPC Peering Connection between VPC A and VPC B"
  value       = aws_vpc_peering_connection.peer_a_b.id
}

output "vpc_peering_region" {
  description = "The region of the VPC Peering Connection"
  value       = aws_vpc_peering_connection.peer_a_b.region
}
