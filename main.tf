terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
      version = "2.30.0"
    }
  }
}

data "azuread_client_config" "current" {} # Authenticated account via az login in Home tenant
resource "random_uuid" "scope-id" {}
resource "random_uuid" "custom-scope" {}
