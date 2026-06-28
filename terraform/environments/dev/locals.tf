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
}
