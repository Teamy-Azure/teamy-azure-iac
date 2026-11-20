resource "azurerm_federated_identity_credential" "cert_manager_dns" {
  name = "cert-manager-candidate"
  parent_id = azurerm_user_assigned_identity.cert_manager_dns.id
  resource_group_name = data.azurerm_resource_group.main.name
  audience = ["api://AzureADTokenExchange"]
  issuer = data.azurerm_kubernetes_cluster.candidate.oidc_issuer_url
  subject = "system:serviceaccount:cert-manager:cert-manager"
}
