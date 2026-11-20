resource "azurerm_federated_identity_credential" "aks" {
  name = "personal-aks"
  parent_id = azurerm_user_assigned_identity.this.id
  issuer = data.azurerm_kubernetes_cluster.personal.oidc_issuer_url
  subject = "system:serviceaccount:teamy-github-readme-stats:teamy-github-readme-stats"
  audience = ["api://AzureADTokenExchange"]
}
