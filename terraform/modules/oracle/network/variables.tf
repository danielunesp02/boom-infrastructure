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
  description = "VCN CIDR block"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "Public subnet CIDR block"
  default     = "10.0.1.0/24"
}

variable "common_tags" {
  type        = map(string)
  description = "Common resource tags"
  default     = {}
}
