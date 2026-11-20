# Keep for recovery of these existing resources; comment out for a fresh deployment.
import {
  to = azurerm_storage_account.main
  id = "/subscriptions/6cb7032f-2437-4f5e-91e8-676cb67e5444/resourceGroups/Personal.Core.StateFile.RG/providers/Microsoft.Storage/storageAccounts/personalcorestatefile"
}

resource "azurerm_storage_account" "main" {
  name                     = "personalcorestatefile"
  resource_group_name      = data.azurerm_resource_group.main.name
  location                 = "canadacentral"
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  allow_nested_items_to_be_public = false
  public_network_access_enabled   = true

  network_rules {
    default_action = "Deny"
    bypass         = ["None"]
    ip_rules = [
      trimspace(data.http.public_ip.response_body)
    ]
  }

  tags = {
    partition  = "Personal"
    managed_by = "Terraform"
    purpose    = "Personal Terraform state"
  }

  lifecycle {
    prevent_destroy = true
    # The networking sibling contributes subnet rules; keep IP/default policy here.
    ignore_changes = [network_rules[0].virtual_network_subnet_ids]
  }
}
