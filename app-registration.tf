# Registered in Home tenant
resource "azuread_application" "this" {
  provider = azuread.home
  display_name     = var.app-name
  owners           = [data.azuread_client_config.current.object_id] # Home tenant
  sign_in_audience = "AzureADMultipleOrgs" # App is a multi-tenant App Registration
  identifier_uris  = ["api://${var.app-name}"]
  fallback_public_client_enabled = true # ROPC flow defaults to public client (not confidential client)

  public_client {
    redirect_uris = ["https://localhost/${var.app-name}"]
  }

  api {
    mapped_claims_enabled          = true
    requested_access_token_version = 2

    oauth2_permission_scope {
      admin_consent_description  =  "Allow user to get roles claim"
      admin_consent_display_name =  "Roles claims"
      enabled                    =  true
      id                         =  random_uuid.scope-id.result
      type                       =  "User"
      value                      =  "getroles"
      user_consent_description   =  "Allow user to get roles claim"
      user_consent_display_name  =  "Roles claims"
    }
  }

  app_role {
    allowed_member_types = ["User", "Application"]
    description          = "Read"
    display_name         = "Read role for service"
    enabled              = true
    id                   = random_uuid.custom-scope.result
    value                = "Read"
  }
}
