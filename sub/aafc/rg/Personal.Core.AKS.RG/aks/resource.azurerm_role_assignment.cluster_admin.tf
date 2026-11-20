resource "azurerm_role_assignment" "cluster_admin" {
  scope = azurerm_kubernetes_cluster.this.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id = "7925a047-b9c8-408b-9cbf-91b73758db87"
  principal_type = "Group"
}
