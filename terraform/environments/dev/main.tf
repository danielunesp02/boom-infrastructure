locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "network" {
  source           = "../../modules/oracle/network"
  compartment_ocid = var.compartment_ocid
  name_prefix      = local.name_prefix
}

module "compute" {
  source              = "../../modules/oracle/compute"
  compartment_ocid    = var.compartment_ocid
  availability_domain = var.availability_domain
  name_prefix         = local.name_prefix
  subnet_id           = module.network.public_subnet_id
  ssh_public_key      = var.ssh_public_key
}
