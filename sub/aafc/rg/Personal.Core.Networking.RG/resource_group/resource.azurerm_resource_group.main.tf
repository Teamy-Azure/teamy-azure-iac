resource "azurerm_resource_group" "main" {
  name     = "Personal.Core.Networking.RG"
  location = "canadacentral"

  tags = {
    partition  = "Personal"
    managed_by = "Terraform"
    purpose    = "Personal networking"
  }

  lifecycle {
    prevent_destroy = true
  }
}
