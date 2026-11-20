data "azurerm_user_assigned_identity" "legacy_dns" {
  name = "dns-contributor"
  resource_group_name = "CACN-ClusterWorkload-Benthic-azurewebsiets-PROD-RG"
}
