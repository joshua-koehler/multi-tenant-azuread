# Home Tenant - Where App Registration lives
provider "azuread" {
  alias = "home"
  tenant_id = var.home-tenant-id
}

/* Groups portion - we assign roles to groups and users to those groups - Requires AAD premium license
// Alternative to assigning role directly to home-client
 resource "azuread_group" "read-group" {
   display_name     = "Read"
   owners           = [data.azuread_client_config.current.object_id]
   security_enabled = true
   assignable_to_role = true
   members = [azuread_user.home-client.object_id]
 }
 resource "azuread_app_role_assignment" "read-group" {
   app_role_id         = azuread_service_principal.home.app_role_ids["Read"]
   principal_object_id = azuread_group.read-group.object_id
   resource_object_id  = azuread_service_principal.home.object_id
 }
 End Groups Portion */

# Create this to test ROPC flow in home tenant
resource "azuread_user" "home-client" {
  provider = azuread.home
  display_name        = "Home Client"
  password            = var.home-client-password
  disable_strong_password = true
  user_principal_name = var.home-client-user_principal_name
}

# Owner of App Registration
resource "azuread_user" "home-owner" {
  provider = azuread.home
  display_name        = "Home Owner"
  password            = var.home-owner-password
  disable_strong_password = true
  user_principal_name = var.home-owner-user_principal_name
}

# App Instance (aka Service Principal) of App Registration in home tenant
resource "azuread_service_principal" "home" {
  provider = azuread.home
  application_id               = azuread_application.this.application_id
  app_role_assignment_required = false
  owners = [azuread_user.home-owner.object_id]
}

# Assign home-client User Principal the "Read" role via the App Instance 
resource "azuread_app_role_assignment" "home" {
  provider = azuread.home
  app_role_id         = azuread_service_principal.home.app_role_ids["Read"]
  principal_object_id = azuread_user.home-client.object_id
  resource_object_id  = azuread_service_principal.home.object_id
}