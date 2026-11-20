resource "azurerm_role_assignment" "retained_reader" {
  scope = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets User"
  principal_id = data.azurerm_user_assigned_identity.legacy.principal_id
}
