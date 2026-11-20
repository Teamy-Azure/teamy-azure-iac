resource "azurerm_resource_group" "main" {
  name     = "Personal.Workload.AKS.GitHub-README-Stats.RG"
  location = "canadacentral"

  tags = {
    partition  = "Personal"
    managed_by = "Terraform"
    purpose    = "GitHub README Stats workload"
  }

  lifecycle {
    prevent_destroy = true
  }
}
