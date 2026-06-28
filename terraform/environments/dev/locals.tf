locals {
  project_name = var.project_name
  environment  = var.environment

  resource_prefix = "${local.project_name}-${local.environment}"

  common_tags = {
    Project     = "Boom"
    Environment = local.environment
    ManagedBy   = "Terraform"
    Owner       = "Daniel Bevilacqua"
  }

  target_compartment_ocid = var.create_project_compartment ? module.project_compartment[0].compartment_id : var.compartment_ocid
}
