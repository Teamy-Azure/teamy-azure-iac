resource "azapi_resource" "virtual_network" {
  type      = "Microsoft.Network/virtualNetworks@2025-05-01"
  name      = "TEAMY-NETWORK-VNET"
  location  = "canadacentral"
  parent_id = data.azapi_resource.resource_group.id
  body = {
    properties = {
      addressSpace = {
        addressPrefixes = ["10.203.0.0/16"]
      }
      dhcpOptions = {
        dnsServers = []
      }
    }
  }
}
