variable "new_compartment_name" {
  description = "The name of the compartment to create to contain the application"
  default     = "AlwaysFreeApplication"
  type        = string
}

variable "parent_compartment_id" {
  description = "The OCID of the compartment to create a new one within"
  type        = string
}

variable "project_name" {
  description = "The name of the project to use as a prefix in resource names"
  type        = string
  default     = "app"
}

variable "number_of_instances" {
  description = "The number of simultaneously running instances."
  type        = number
  default     = 2
}

variable "tenancy_ocid" {

}
variable "user_ocid" {

}
variable "fingerprint" {

}
variable "private_key_path" {

}
variable "region" {
  description = "The region to deploy the infrastructure to."
}
