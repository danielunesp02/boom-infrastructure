output "instance_id" {
  description = "Compute instance OCID"
  value       = oci_core_instance.app.id
}

output "public_ip" {
  description = "Compute instance public IP"
  value       = oci_core_instance.app.public_ip
}
