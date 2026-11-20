resource "azurerm_role_assignment" "content_writer" {
  scope = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id = "69a5068e-fbdb-4fd4-b31c-6c4917f30551"
}
