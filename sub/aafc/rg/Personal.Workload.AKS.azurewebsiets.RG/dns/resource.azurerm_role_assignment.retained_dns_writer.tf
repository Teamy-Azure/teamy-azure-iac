resource "azurerm_role_assignment" "retained_dns_writer" {
  scope = azurerm_dns_zone.this.id
  role_definition_name = "DNS Zone Contributor"
  principal_id = data.azurerm_user_assigned_identity.legacy_dns.principal_id
}
