resource "azurerm_user_assigned_identity" "control_plane" {
  name = "Personal-AKS-ControlPlane"
  resource_group_name = data.azurerm_resource_group.main.name
  location = "canadacentral"
  tags = {
    partition  = "Personal"
    managed_by = "Terraform"
    purpose    = "Personal AKS and core NGINX storage"
  }
  lifecycle { prevent_destroy = true }
}
