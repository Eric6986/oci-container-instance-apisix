terraform {
  required_version = ">= 1.0.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 5.21.0"
      # https://registry.terraform.io/providers/hashicorp/oci/5.21.0
    }
  }
}