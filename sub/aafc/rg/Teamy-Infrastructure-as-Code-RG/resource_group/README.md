# Teamy-Infrastructure-as-Code-RG resource group

This root owns the `Teamy-Infrastructure-as-Code-RG` resource group.

The storage account is managed by the sibling `storage_account` root so that
resource-group lifecycle and workload lifecycle remain separate.

This root was bootstrapped with local state, then migrated to the Azure
Storage backend at:

```text
resource-groups/Teamy-Infrastructure-as-Code-RG/resource_group.tfstate
```
