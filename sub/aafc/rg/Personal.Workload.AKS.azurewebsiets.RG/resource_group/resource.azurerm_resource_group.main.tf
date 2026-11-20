resource "azurerm_resource_group" "main" {
  name     = "Personal.Workload.AKS.azurewebsiets.RG"
  location = "canadacentral"

  tags = {
    partition  = "Personal"
    managed_by = "Terraform"
    purpose    = "Azure websites workload"
  }

  lifecycle {
    prevent_destroy = true
  }
}
