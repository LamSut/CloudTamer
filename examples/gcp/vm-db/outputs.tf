#################
### GCP VM IP ###
#################

# output "win_vm_ips" {
#   value = module.vm.win_vm_ips
# }

output "rhel_vm_ips" {
  value = module.vm.rhel_vm_ips
}

output "debian_vm_ips" {
  value = module.vm.debian_vm_ips
}


##################
### SSH Access ###
##################

# output "win_vm_ssh_commands" {
#   description = "Gcloud SSH commands for Windows VMs"
#   value = [
#     for i in range(length(module.vm.win_vm_names)) :
#     "gcloud compute ssh ${module.vm.win_vm_names[i]} --zone ${module.vm.win_vm_zones[i]} --project ${var.project_id}"
#   ]
# }

output "rhel_vm_ssh_commands" {
  description = "Gcloud SSH commands for RHEL VMs"
  value = [
    for i in range(length(module.vm.rhel_vm_names)) :
    "gcloud compute ssh ${var.vm_user}@${module.vm.rhel_vm_names[i]} --zone ${module.vm.rhel_vm_zones[i]} --project ${var.project_id}"
  ]
}

output "debian_vm_ssh_commands" {
  description = "Gcloud SSH commands for Debian VMs"
  value = [
    for i in range(length(module.vm.debian_vm_names)) :
    "gcloud compute ssh ${var.vm_user}@${module.vm.debian_vm_names[i]} --zone ${module.vm.debian_vm_zones[i]} --project ${var.project_id}"
  ]
}
