provider "oci" {
  // TODO: Ignore OCI default tags.
  ignore_defined_tags = []

  tenancy_ocid = var.tenancy_ocid
  region       = var.region
}
