resource "azurerm_role_assignment" "subnet_network_contributor" {
  scope = data.azurerm_subnet.aks.id
  role_definition_name = "Network Contributor"
  principal_id = azurerm_user_assigned_identity.control_plane.principal_id
  principal_type = "ServicePrincipal"
}
