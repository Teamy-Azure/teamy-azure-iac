resource "azurerm_role_assignment" "key_vault_secrets_user" {
  scope = data.azurerm_key_vault.retained.id
  role_definition_name = "Key Vault Secrets User"
  principal_id = azurerm_user_assigned_identity.this.principal_id
  principal_type = "ServicePrincipal"
}
