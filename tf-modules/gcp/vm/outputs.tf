
##############
### VM IPs ###
##############

# output "win_vm_ips" {
#   value = google_compute_address.win_ip[*].address
# }

output "rhel_vm_ips" {
  value = google_compute_address.rhel_ip[*].address
}

output "debian_vm_ips" {
  value = google_compute_address.debian_ip[*].address
}


################
### VM Names ###
################

# output "win_vm_names" {
#   value = google_compute_instance.win_vm[*].name
# }

output "rhel_vm_names" {
  value = google_compute_instance.rhel_vm[*].name
}

output "debian_vm_names" {
  value = google_compute_instance.debian_vm[*].name
}


################
### VM Zones ###
################

# output "win_vm_zones" {
#   value = google_compute_instance.win_vm[*].zone
# }

output "rhel_vm_zones" {
  value = google_compute_instance.rhel_vm[*].zone
}

output "debian_vm_zones" {
  value = google_compute_instance.debian_vm[*].zone
}
