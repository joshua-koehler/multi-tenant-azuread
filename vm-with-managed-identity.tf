provider azurerm {
    alias = "foreign"
    tenant_id = var.foreign-tenant-id
    features {}
}

resource "azurerm_resource_group" "this" {
  provider = azurerm.foreign
  name     = "foreign-vm-with-managed-identity"
  location = var.vm-location
}

# Principal representing foreign Client 
resource "azurerm_user_assigned_identity" "this" {
  provider = azurerm.foreign
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  name = "foreign-client-managed-identity"
}

# Assign Role to Principal in foreign tenant
resource "azuread_app_role_assignment" "this" {
  provider = azuread.foreign
  app_role_id         = azuread_service_principal.foreign.app_role_ids["Read"]
  principal_object_id = azurerm_user_assigned_identity.this.principal_id
  resource_object_id  = azuread_service_principal.foreign.object_id
}

# vm with user assigned managed identity
resource "azurerm_linux_virtual_machine" "this" {
  provider = azurerm.foreign
  name                = "machine"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  size                = var.vm-size
  admin_username      = var.ssh-username
  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.this.id]
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "this" {
  provider = azurerm.foreign
  name                 = "jre"
  virtual_machine_id   = azurerm_linux_virtual_machine.this.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
 {
  "commandToExecute": "sudo apt install -y default-jre"
 }
SETTINGS
}

# vnet needed for vm
resource "azurerm_virtual_network" "this" {
  provider = azurerm.foreign
  name                = "network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

# subnet needed for vm
resource "azurerm_subnet" "this" {
  provider = azurerm.foreign
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.2.0/24"]
}

# nic needed for vm
resource "azurerm_network_interface" "this" {
  provider = azurerm.foreign
  name                = "nic"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this.id
  }
}

resource "azurerm_public_ip" "this" {
  provider = azurerm.foreign
  name                = "public_ip"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Static"
}