output "compartment_id" {
  description = "Created compartment OCID"
  value       = oci_identity_compartment.this.id
}
