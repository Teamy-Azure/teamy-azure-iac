# Keep for recovery of these existing resources; comment out for a fresh deployment.
import {
  to = azurerm_role_assignment.operator_state_writer
  id = "/subscriptions/6cb7032f-2437-4f5e-91e8-676cb67e5444/resourceGroups/Personal.Core.StateFile.RG/providers/Microsoft.Storage/storageAccounts/personalcorestatefile/blobServices/default/containers/statefiles/providers/Microsoft.Authorization/roleAssignments/b677ed93-2959-d5aa-d89e-a607c40438f0"
}




# Keep the deployed bootstrap writer fixed when a different operator recovers state.
resource "azurerm_role_assignment" "operator_state_writer" {
  scope = azurerm_storage_container.statefiles.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id = "69a5068e-fbdb-4fd4-b31c-6c4917f30551"
}
