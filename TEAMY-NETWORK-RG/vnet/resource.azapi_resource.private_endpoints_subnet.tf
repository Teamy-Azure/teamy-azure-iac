resource "azapi_resource" "private_endpoints_subnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2025-05-01"
  name      = "TEAMY-PRIVATE-ENDPOINTS-SUBNET"
  parent_id = azapi_resource.virtual_network.id
  depends_on = [
    azapi_resource.gateway_subnet, # fixes "Another operation on this or dependent resource is in progress."
  ]
  body = {
    properties = {
      addressPrefix                  = "10.203.1.0/24"
      privateEndpointNetworkPolicies = "Disabled"
    }
  }
}