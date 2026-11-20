resource "azurerm_subnet" "private_endpoints" {
  name                              = "PrivateEndpointsSubnet"
  resource_group_name               = data.azurerm_resource_group.main.name
  virtual_network_name              = azurerm_virtual_network.this.name
  address_prefixes                  = ["10.204.1.0/24"]
  private_endpoint_network_policies = "Disabled"

  lifecycle {
    prevent_destroy = true
  }
}
