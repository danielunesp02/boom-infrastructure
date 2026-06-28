output "vcn_id" {
  description = "VCN OCID"
  value       = oci_core_vcn.main.id
}

output "public_subnet_id" {
  description = "Public subnet OCID"
  value       = oci_core_subnet.public.id
}
