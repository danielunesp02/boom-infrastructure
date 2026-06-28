variable "tenancy_ocid" {
  type        = string
  description = "OCI tenancy OCID"
}

variable "user_ocid" {
  type        = string
  description = "OCI user OCID"
}

variable "fingerprint" {
  type        = string
  description = "OCI API key fingerprint"
}

variable "private_key_path" {
  type        = string
  description = "Path to OCI API private key"
}

variable "region" {
  type        = string
  description = "OCI region"
}

variable "compartment_ocid" {
  type        = string
  description = "Fallback OCI compartment OCID. For small setups, this may be the tenancy OCID."
}

variable "availability_domain" {
  type        = string
  description = "OCI availability domain name"
}

variable "ssh_public_key" {
  type        = string
  description = "Public SSH key used to access the compute instance"
}

variable "project_name" {
  type        = string
  description = "Project name used for resource naming"
  default     = "boom"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

variable "create_project_compartment" {
  type        = bool
  description = "Whether Terraform should create a dedicated project compartment"
  default     = true
}

variable "project_compartment_name" {
  type        = string
  description = "Dedicated project compartment name"
  default     = "Boom"
}

variable "allowed_ssh_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed to access SSH"
}

variable "instance_shape" {
  type        = string
  description = "OCI compute instance shape"
  default     = "VM.Standard.A1.Flex"
}

variable "instance_ocpus" {
  type        = number
  description = "Number of OCPUs for the instance"
  default     = 1
}

variable "instance_memory_gb" {
  type        = number
  description = "Memory in GB for the instance"
  default     = 6
}

variable "boot_volume_size_gb" {
  type        = number
  description = "Boot volume size in GB"
  default     = 50
}

variable "image_operating_system" {
  type        = string
  description = "Operating system image"
  default     = "Canonical Ubuntu"
}

variable "image_operating_system_version" {
  type        = string
  description = "Operating system version"
  default     = "22.04"
}
