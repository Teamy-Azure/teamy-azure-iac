output "subnet_ids" {
  value = {
    gateway           = azurerm_subnet.gateway.id
    private_endpoints = azurerm_subnet.private_endpoints.id
    aks               = azurerm_subnet.aks.id
  }
}
