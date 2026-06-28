variable "tenancy_ocid" { type = string }
variable "user_ocid" { type = string }
variable "fingerprint" { type = string }
variable "private_key_path" { type = string }
variable "region" { type = string }
variable "compartment_ocid" { type = string }
variable "availability_domain" { type = string }
variable "ssh_public_key" { type = string }

variable "project_name" {
  type    = string
  default = "boom"
}

variable "environment" {
  type    = string
  default = "dev"
}
