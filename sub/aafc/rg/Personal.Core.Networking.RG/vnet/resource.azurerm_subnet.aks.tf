# Reserved for a future deliberately recreated AKS cluster.
# No existing AKS cluster is rebound to this subnet by this scaffold.
resource "azurerm_subnet" "aks" {
  name                 = "AKSSubnet"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.204.4.0/22"]
  service_endpoints    = ["Microsoft.Storage"]

  lifecycle {
    prevent_destroy = true
  }
}
