output "app-registration-id" {
  value = azuread_application.this.application_id
}
output "scope-to-request-in-order-to-get-token-with-roles" {
  value = "${one(azuread_application.this.identifier_uris)}/getroles"
}
output "home-client-user-principal-name" {
  value = azuread_user.home-client.user_principal_name
}
output "home-owner-user-principal-name" {
  value = azuread_user.home-owner.user_principal_name
}
output "foreign-client-user-principal-name" {
  value = azuread_user.foreign-client.user_principal_name
}
output "foreign-owner-user-principal-name" {
  value = azuread_user.foreign-owner.user_principal_name
}
output "foreign-client-ropc-command" {
  value = "java -jar get-access-token-with-resource-owner-password-credentials-grant.jar ${var.foreign-client-password} ${var.foreign-client_user_principal_name} ${azuread_application.this.application_id} ${var.foreign-tenant-id} ${one(azuread_application.this.identifier_uris)}/getroles"
}
output "home-client-ropc-command" {
  value = "java -jar get-access-token-with-resource-owner-password-credentials-grant.jar ${var.home-client-password} ${var.home-client-user_principal_name} ${azuread_application.this.application_id} ${var.home-tenant-id} ${one(azuread_application.this.identifier_uris)}/getroles"
}
output public_ip_address {
  value = azurerm_public_ip.this.ip_address
}
output vm-ssh-username {
  value = var.ssh-username
}