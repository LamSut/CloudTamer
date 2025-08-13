output "vpc_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.vpc_b.name
}

output "vpc_self_link" {
  description = "Self link of the VPC network"
  value       = google_compute_network.vpc_b.self_link
}

output "public_subnet_1_self_link" {
  description = "Self link of the public subnet"
  value       = google_compute_subnetwork.vpc_b_public_subnet_1.self_link
}

output "private_subnet_1_self_link" {
  description = "Self link of the first private subnet"
  value       = google_compute_subnetwork.vpc_b_private_subnet_1.self_link
}

output "private_subnet_2_self_link" {
  description = "Self link of the second private subnet"
  value       = google_compute_subnetwork.vpc_b_private_subnet_2.self_link
}
