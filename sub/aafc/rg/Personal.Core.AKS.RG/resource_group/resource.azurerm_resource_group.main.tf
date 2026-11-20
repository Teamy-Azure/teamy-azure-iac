resource "azurerm_resource_group" "main" {
  name     = "Personal.Core.AKS.RG"
  location = "canadacentral"

  tags = {
    partition  = "Personal"
    managed_by = "Terraform"
    purpose    = "Personal AKS and core NGINX storage"
  }

  lifecycle {
    prevent_destroy = true
  }
}
