variable "new_compartment_name" {
  description = "The name of the compartment to create to contain the application"
  default     = "AlwaysFreeApplication"
  type        = string
}

variable "parent_compartment_id" {
  description = "The OCID of the compartment to create a new one within"
  default     = var.tenancy_ocid
  type        = string
}

variable "project_name" {
  description = "The name of the project to use as a prefix in resource names"
  default     = "app"
  type        = string
}

variable "number_of_instances" {
  description = "The number of simultaneously running instances. They use 1 OCPU / 6 GB configuration, so should be from 1 to 4 for a free tier. "
  default     = 2
  type        = number
}

variable "tenancy_ocid" {
  description = "The OCID of the root tenancy."
  type        = string
}

variable "region" {
  description = "The region to deploy the infrastructure to."
  type        = string
}
