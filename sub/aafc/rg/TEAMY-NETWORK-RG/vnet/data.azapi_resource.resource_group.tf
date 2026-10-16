data "azapi_resource" "resource_group" {
  type      = "Microsoft.Resources/resourceGroups@2025-04-01"
  name      = "TEAMY-NETWORK-RG"
  parent_id = "/subscriptions/6cb7032f-2437-4f5e-91e8-676cb67e5444"
}
