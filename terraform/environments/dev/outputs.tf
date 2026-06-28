output "project_compartment_id" {
  description = "Project compartment OCID"
  value       = local.target_compartment_ocid
}

output "instance_public_ip" {
  description = "Public IP address of the Boom application instance"
  value       = module.compute.public_ip
}

output "instance_id" {
  description = "OCI instance OCID"
  value       = module.compute.instance_id
}

output "ssh_command" {
  description = "SSH command to access the instance"
  value       = "ssh ubuntu@${module.compute.public_ip}"
}

output "vcn_id" {
  description = "VCN OCID"
  value       = module.network.vcn_id
}

output "resource_prefix" {
  description = "Resource naming prefix"
  value       = local.resource_prefix
}
