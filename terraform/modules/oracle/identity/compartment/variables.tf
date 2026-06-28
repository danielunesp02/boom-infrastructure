variable "tenancy_ocid" {
  type        = string
  description = "OCI tenancy OCID where the project compartment will be created"
}

variable "name" {
  type        = string
  description = "Compartment name"
}

variable "description" {
  type        = string
  description = "Compartment description"
}

variable "common_tags" {
  type        = map(string)
  description = "Common resource tags"
  default     = {}
}
