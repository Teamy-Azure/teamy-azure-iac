output "dns_identity_client_id" {
  value = azurerm_user_assigned_identity.cert_manager_dns.client_id
}
