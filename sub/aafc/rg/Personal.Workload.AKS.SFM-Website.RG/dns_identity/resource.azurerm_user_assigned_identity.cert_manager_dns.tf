resource "azurerm_user_assigned_identity" "cert_manager_dns" {
  name = "sfm-website-cert-manager-dns"
  resource_group_name = data.azurerm_resource_group.main.name
  location = "canadacentral"
  tags = {
    partition = "Personal"
    managed_by = "Terraform"
    purpose = "SFM website workload"
  }
  lifecycle {
    prevent_destroy = true
  }
}
