data "azurerm_dns_zone" "this" {
  name = "azurewebsiets.net"
  resource_group_name = "CACN-ClusterWorkload-Benthic-azurewebsiets-PROD-RG"
}
