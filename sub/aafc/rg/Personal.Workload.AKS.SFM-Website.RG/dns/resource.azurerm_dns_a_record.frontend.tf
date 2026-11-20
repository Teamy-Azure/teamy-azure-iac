resource "azurerm_dns_a_record" "frontend" {
  for_each = local.records
  name = each.value
  zone_name = azurerm_dns_zone.this.name
  resource_group_name = data.azurerm_resource_group.main.name
  ttl = 60
  records = [var.traffic_ipv4_address]
  lifecycle {
    prevent_destroy = true
  }
}
