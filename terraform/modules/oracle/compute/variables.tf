variable "compartment_ocid" { type = string }
variable "availability_domain" { type = string }
variable "name_prefix" { type = string }
variable "subnet_id" { type = string }
variable "ssh_public_key" { type = string }

variable "instance_shape" {
  type    = string
  default = "VM.Standard.A1.Flex"
}

variable "instance_ocpus" {
  type    = number
  default = 1
}

variable "instance_memory_gb" {
  type    = number
  default = 6
}

variable "boot_volume_size_gb" {
  type    = number
  default = 50
}

variable "image_operating_system" {
  type    = string
  default = "Canonical Ubuntu"
}

variable "image_operating_system_version" {
  type    = string
  default = "22.04"
}
