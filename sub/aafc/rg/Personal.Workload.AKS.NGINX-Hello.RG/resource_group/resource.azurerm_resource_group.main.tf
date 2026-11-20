resource "azurerm_resource_group" "main" {
  name = "Personal.Workload.AKS.NGINX-Hello.RG"
  location = "canadacentral"
  tags = {
    partition = "Personal"
    managed_by = "Terraform"
    purpose = "NGINX hello workload"
  }
  lifecycle { prevent_destroy = true }
}
