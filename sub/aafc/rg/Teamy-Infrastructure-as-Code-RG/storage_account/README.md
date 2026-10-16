# Teamy Infrastructure as Code storage

This root owns the `teamyiac` storage account and its private `statefiles`
container.

## Bootstrap order

1. Apply `../resource_group` using local state.
2. Apply this root using local state.
3. Add the backend block and run `terraform init -migrate-state`.
4. Configure future Terraform roots to use the Azure Storage backend:

```hcl
terraform {
  backend "azurerm" {
    subscription_id      = "6cb7032f-2437-4f5e-91e8-676cb67e5444"
    resource_group_name  = "Teamy-Infrastructure-as-Code-RG"
    storage_account_name = "teamyiac"
    container_name       = "statefiles"
    key                  = "<root-specific-state-key>.tfstate"
  }
}
```

This root now uses the Azure Storage backend after its initial local state was
migrated. Its state key is:

```text
resource-groups/Teamy-Infrastructure-as-Code-RG/storage_account.tfstate
```

The storage account uses default-deny networking, permits Azure services, and
allows the public IPv4 address returned by `https://ipv4.icanhazip.com`.
