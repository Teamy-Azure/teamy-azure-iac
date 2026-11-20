data "azurerm_user_assigned_identity" "dns" {
  name = "azurewebsiets-cert-manager-dns"
  resource_group_name = "Personal.Workload.AKS.azurewebsiets.RG"
}
