data "azurerm_user_assigned_identity" "dns" {
  name = "sfm-website-cert-manager-dns"
  resource_group_name = "Personal.Workload.AKS.SFM-Website.RG"
}
