# Multi-Tenant Azure AD - Terraform Infrastructure

## Terraform Infrastructure to set up:
* App Registration in home tenant defining custom:
  *  App Role
  * Scopes
* Service Principal in home tenant
* Service Principal in foreign tenant
* User Principal in home tenant
* User Principal in foreign tenant
* User Principal in foreign tenant (owner of the Service Principal in foreign tenant)
* App Role Assignment to home User Principal in home tenant
* App Role Assignment to foreign User Principal in foreign tenant

## With this setup a User Principal should login to his proper tenant and receive a token containing his app role in the roles claim
