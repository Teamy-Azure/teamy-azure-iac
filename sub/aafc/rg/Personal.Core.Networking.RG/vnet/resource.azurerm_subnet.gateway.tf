resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.204.0.0/27"]

  lifecycle {
    prevent_destroy = true
  }
}
