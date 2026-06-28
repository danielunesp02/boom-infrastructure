resource "oci_identity_compartment" "this" {
  compartment_id = var.tenancy_ocid
  name           = var.name
  description    = var.description
  enable_delete  = true

  freeform_tags = var.common_tags
}
