# Foreign Tenant - Where *an* App Instance (aka Service Principal) lives
provider "azuread" {
  alias = "foreign"
  tenant_id = var.foreign-tenant-id
}

# User that logs in and gets a token with a roles claim
resource "azuread_user" "foreign-client" {
  provider = azuread.foreign
  display_name        = "Foreign-Tenant Client"
  password            = var.foreign-client-password
  disable_strong_password = true
  user_principal_name = var.foreign-client_user_principal_name 
}

# Created because we need a User Principal in the foreign tenant to set as service_principal owner below
resource "azuread_user" "foreign-owner" {
  provider = azuread.foreign
  display_name        = "Foreign-Tenant Owner"
  password            = var.foreign-owner_password
  disable_strong_password = true
  user_principal_name = var.foreign-owner_user_principal_name 
}

# This is an App Instance in the foreign tenant of the App Registration in the home tenant
resource "azuread_service_principal" "foreign" {
  provider = azuread.foreign
  application_id               = azuread_application.this.application_id
  app_role_assignment_required = false
  owners                       = [azuread_user.foreign-owner.object_id]
}

# Assign Read role to foreign-client User Principal
# This User will receive "Read" in the roles claim when getting a token
resource "azuread_app_role_assignment" "foreign" {
  provider = azuread.foreign
  app_role_id         = azuread_service_principal.foreign.app_role_ids["Read"]
  principal_object_id = azuread_user.foreign-client.object_id
  resource_object_id  = azuread_service_principal.foreign.object_id
}

