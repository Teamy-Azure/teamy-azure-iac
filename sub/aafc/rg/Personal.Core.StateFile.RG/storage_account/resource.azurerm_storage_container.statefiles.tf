# Keep for recovery of these existing resources; comment out for a fresh deployment.
import {
  to = azurerm_storage_container.statefiles
  id = "/subscriptions/6cb7032f-2437-4f5e-91e8-676cb67e5444/resourceGroups/Personal.Core.StateFile.RG/providers/Microsoft.Storage/storageAccounts/personalcorestatefile/blobServices/default/containers/statefiles"
}

resource "azurerm_storage_container" "statefiles" {
  name                  = "statefiles"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}
