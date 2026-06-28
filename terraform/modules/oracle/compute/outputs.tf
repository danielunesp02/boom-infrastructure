output "instance_id" {
  value = oci_core_instance.app.id
}

output "public_ip" {
  value = oci_core_instance.app.public_ip
}
