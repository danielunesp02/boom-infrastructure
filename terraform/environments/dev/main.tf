module "project_compartment" {
  count = var.create_project_compartment ? 1 : 0

  source = "../../modules/oracle/identity/compartment"

  tenancy_ocid = var.tenancy_ocid
  name         = var.project_compartment_name
  description  = "Boom project compartment managed by Terraform"

  common_tags = local.common_tags
}

module "network" {
  source = "../../modules/oracle/network"

  compartment_ocid  = local.target_compartment_ocid
  name_prefix       = local.resource_prefix
  allowed_ssh_cidrs = var.allowed_ssh_cidrs
  common_tags       = local.common_tags
}

module "compute" {
  source = "../../modules/oracle/compute"

  compartment_ocid    = local.target_compartment_ocid
  availability_domain = var.availability_domain
  name_prefix         = local.resource_prefix
  subnet_id           = module.network.public_subnet_id
  ssh_public_key      = var.ssh_public_key

  instance_shape      = var.instance_shape
  instance_ocpus      = var.instance_ocpus
  instance_memory_gb  = var.instance_memory_gb
  boot_volume_size_gb = var.boot_volume_size_gb

  image_operating_system         = var.image_operating_system
  image_operating_system_version = var.image_operating_system_version

  common_tags = local.common_tags
}
