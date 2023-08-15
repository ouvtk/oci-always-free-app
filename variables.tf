variable "new_compartment_name" {
  description = "Name of the compartment to create to contain the application"
  default     = "AlwaysFreeApplication"
  type        = string
}

variable "parent_compartment_id" {
  description = "The OCID of the compartment to create a new one within"
  type        = string
}

variable "project_name" {
  description = "Name of the project to use as a prefix in resource names"
  type        = string
  default     = "app"
}
