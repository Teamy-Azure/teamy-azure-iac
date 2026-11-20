data "azurerm_subnet" "aks" {
  name                 = "AKSSubnet"
  virtual_network_name = "Personal.Core.Networking.VNET"
  resource_group_name  = "Personal.Core.Networking.RG"
}
