# Multi-Tenant Azure AD - Terraform Infrastructure

## Terraform Infrastructure to set up:
* App Registration in home tenant defining custom:
  *  App Role
  * Scopes
* Service Principal in home tenant
* Service Principal in foreign tenant
* User Principal in home tenant - client
* User Principal in home tenant - owner of the App Registration and Service Principal in home tenant
* User Principal in foreign tenant - client
* User Principal in foreign tenant - owner of the Service Principal in foreign tenant
* App Role Assignment to home-client User Principal in home tenant
* App Role Assignment to foreign-client User Principal in foreign tenant
* User Assigned Managed Identity in foreign tenant with "Read" App Role assigned to it
* VM in foreign tenant with Managed Identity assigned to it

## With this setup a User Principal can login to his proper tenant and receive a token containing his app role in the roles claim
* Note that due to a possible internal issue with AzureAD, a User Principal in the foreign tenant *cannot* login
* However the Managed Identity can get a token in the foreign tenant
