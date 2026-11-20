data "azurerm_user_assigned_identity" "legacy_dns" {
  name = "sfm-website-cert-manager-dns"
  resource_group_name = "CACN-ClusterWorkload-Benthic-sfm-website-PROD-RG"
}
