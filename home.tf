# Home Tenant - Where App Registration lives
provider "azuread" {
  alias = "home"
  tenant_id = var.home-tenant-id
}

# Create this to test ROPC flow in home tenant for comparison
resource "azuread_user" "home" {
  provider = azuread.home
  display_name        = "Home Client"
  password            = var.home-password
  disable_strong_password = true
  user_principal_name = var.home-user_principal_name
}

resource "azuread_service_principal" "home" {
  provider = azuread.home
  application_id               = azuread_application.this.application_id
  app_role_assignment_required = false
  # The owner is the Principal logged in when using Terraform - should be home tenant
  owners                       = [data.azuread_client_config.current.object_id] 
}

resource "azuread_app_role_assignment" "home" {
  provider = azuread.home
  app_role_id         = azuread_service_principal.home.app_role_ids["Read"]
  principal_object_id = azuread_user.home.object_id
  resource_object_id  = azuread_service_principal.home.object_id
}
