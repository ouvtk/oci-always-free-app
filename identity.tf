resource "oci_identity_compartment" "app" {
  compartment_id = var.tenancy_ocid

  name        = var.new_compartment_name
  description = "The compartment to contain all infrastructure for the always free application."

  enable_delete = true
}

// Used to decouple from the resource creation in case an existing compartment will be reused.
data "oci_identity_compartment" "app" {
  id = oci_identity_compartment.app.id
}

data "oci_identity_availability_domain" "main" {
  compartment_id = data.oci_identity_compartment.app.id
  ad_number      = 1
}
