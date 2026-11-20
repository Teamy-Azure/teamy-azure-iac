import {
  for_each = local.records
  to = azurerm_dns_a_record.frontend[each.key]
  id = format("%s/A/%s", "/subscriptions/6cb7032f-2437-4f5e-91e8-676cb67e5444/resourceGroups/Personal.Workload.AKS.SFM-Website.RG/providers/Microsoft.Network/dnszones/superfactorymanager.ca", each.value)
}
