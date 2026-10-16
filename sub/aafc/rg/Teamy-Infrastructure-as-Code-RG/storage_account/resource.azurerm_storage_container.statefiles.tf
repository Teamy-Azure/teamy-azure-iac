resource "azurerm_storage_container" "statefiles" {
  name                  = "statefiles"
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}
