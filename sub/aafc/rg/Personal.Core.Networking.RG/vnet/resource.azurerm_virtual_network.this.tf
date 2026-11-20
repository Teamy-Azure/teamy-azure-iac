resource "azurerm_virtual_network" "this" {
  name                = "Personal.Core.Networking.VNET"
  location            = "canadacentral"
  resource_group_name = data.azurerm_resource_group.main.name
  address_space       = ["10.204.0.0/16"]
  tags = {
    partition  = "Personal"
    managed_by = "Terraform"
    purpose    = "Personal networking"
  }

  lifecycle {
    prevent_destroy = true
  }
}
