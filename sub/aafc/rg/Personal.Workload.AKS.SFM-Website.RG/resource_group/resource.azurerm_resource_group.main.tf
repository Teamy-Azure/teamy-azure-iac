resource "azurerm_resource_group" "main" {
  name     = "Personal.Workload.AKS.SFM-Website.RG"
  location = "canadacentral"

  tags = {
    partition  = "Personal"
    managed_by = "Terraform"
    purpose    = "SFM website workload"
  }

  lifecycle {
    prevent_destroy = true
  }
}
