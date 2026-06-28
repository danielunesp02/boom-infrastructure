module "network" {
  source = "../../modules/oracle/network"

  compartment_ocid = var.compartment_ocid
  name_prefix      = local.resource_prefix
  common_tags      = local.common_tags
}

module "compute" {
  source = "../../modules/oracle/compute"

  compartment_ocid    = var.compartment_ocid
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
