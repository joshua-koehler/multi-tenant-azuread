variable "app-name" {
	type= string
	nullable = false
}
variable "foreign-tenant-id" {
	type= string
	nullable = false
}
variable "foreign-client-password" {
	type= string
	nullable = false
}
variable "foreign-client_user_principal_name" {
	type= string
	nullable = false
}
variable "foreign-owner_password" {
	type= string
	nullable = false
}
variable "foreign-owner_user_principal_name" {
	type= string
	nullable = false
}
variable "home-tenant-id" {
	type= string
	nullable = false
}
variable "home-password" {
	type= string
	nullable = false
}
variable "home-client-user_principal_name" {
	type= string
	nullable = false
}
variable "home-owner-user_principal_name" {
	type= string
	nullable = false
}
variable "vm-location" {
	type= string
	nullable = false
}
variable "vm-size" {
	type= string
	nullable = false
}
variable "ssh-username" {
	type= string
	nullable = false
	default = "adminuser"
}