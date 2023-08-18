terraform {
  required_version = ">=1.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.8"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2"
    }
  }
}
