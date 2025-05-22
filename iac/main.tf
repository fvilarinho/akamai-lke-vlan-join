# Terraform definition.
terraform {
  # Required providers.
  required_providers {
    null = {
      source = "hashicorp/null"
      version = "3.2.3"
    }

    random = {
      source = "hashicorp/random"
      version = "3.6.3"
    }
  }
}