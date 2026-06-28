variable "compartment_ocid" {
  type        = string
  description = "OCI compartment OCID"
}

variable "availability_domain" {
  type        = string
  description = "OCI availability domain"
}

variable "name_prefix" {
  type        = string
  description = "Resource name prefix"
}

variable "subnet_id" {
  type        = string
  description = "Subnet OCID"
}

variable "ssh_public_key" {
  type        = string
  description = "Public SSH key"
}

variable "instance_shape" {
  type        = string
  description = "OCI compute instance shape"
  default     = "VM.Standard.A1.Flex"
}

variable "instance_ocpus" {
  type        = number
  description = "Number of OCPUs"
  default     = 1
}

variable "instance_memory_gb" {
  type        = number
  description = "Memory in GB"
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

variable "common_tags" {
  type        = map(string)
  description = "Common resource tags"
  default     = {}
}
