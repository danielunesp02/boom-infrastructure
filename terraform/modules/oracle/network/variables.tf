variable "compartment_ocid" {
  type        = string
  description = "OCI compartment OCID"
}

variable "name_prefix" {
  type        = string
  description = "Resource name prefix"
}

variable "vcn_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VCN CIDR block"
}

variable "public_subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "Public subnet CIDR block"
}
