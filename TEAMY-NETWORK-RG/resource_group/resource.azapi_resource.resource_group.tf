resource "azapi_resource" "resource_group" {
  type = "Microsoft.Resources/resourceGroups@2025-04-01"
  name = "TEAMY-NETWORK-RG"
  location = "canadacentral"
}
