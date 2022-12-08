terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
      version = "2.30.0"
    }
  }
}

resource "random_uuid" "scope-id" {}
resource "random_uuid" "custom-scope" {}
