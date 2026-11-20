# Azure Storage updates the ACL as one document. Preserve the operator rule and
# all other existing ACL fields while contributing this endpoint-enabled subnet.
# Serialize this root with bootstrap IP-rule maintenance to avoid stale snapshots.
resource "azapi_update_resource" "statefile_vnet_access" {
  type        = "Microsoft.Storage/storageAccounts@2025-08-01"
  resource_id = data.azapi_resource.main.id

  body = {
    properties = {
      networkAcls = merge(
        data.azapi_resource.main.output.properties.networkAcls,
        {
          virtualNetworkRules = concat(
            [
              for rule in coalesce(try(data.azapi_resource.main.output.properties.networkAcls.virtualNetworkRules, []), []) : {
                for key, value in rule : key => value if key != "state"
              } if lower(rule.id) != lower(data.azurerm_subnet.aks.id)
            ],
            [{ id = data.azurerm_subnet.aks.id, action = "Allow" }]
          )
        }
      )
    }
  }

  list_unique_id_property = {
    "properties.networkAcls.virtualNetworkRules" = "id"
  }

  lifecycle {
    prevent_destroy = true

    precondition {
      condition     = contains(data.azurerm_subnet.aks.service_endpoints, "Microsoft.Storage")
      error_message = "AKSSubnet must already have the Microsoft.Storage service endpoint."
    }

    precondition {
      condition     = data.azapi_resource.main.output.properties.networkAcls.defaultAction == "Deny"
      error_message = "The state account must retain its existing default-deny firewall policy."
    }
  }
}
