data "azurerm_dns_zone" "this" {
  name = "superfactorymanager.ca"
  resource_group_name = "CACN-ClusterWorkload-Benthic-sfm-website-PROD-RG"
}
