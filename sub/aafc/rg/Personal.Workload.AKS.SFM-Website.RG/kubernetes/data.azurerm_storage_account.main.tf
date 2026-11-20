data "azurerm_storage_account" "main" {
  name = "sfmwebsiteprod"
  resource_group_name = "CACN-ClusterWorkload-Benthic-sfm-website-PROD-RG"
}
