resource "azurerm_resource_group" "this" {
  name     = "Teamy-Infrastructure-as-Code-RG"
  location = "canadacentral"

  tags = {
    environment = "Production"
    managed_by  = "Terraform"
    purpose     = "Infrastructure as Code"
  }
}
