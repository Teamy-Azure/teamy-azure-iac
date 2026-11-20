# Personal.Workload.AKS.GitHub-README-Stats.RG

This sibling owns only the destination resource group. `identity`, `runtime`
and `certificate` are independent sibling roots described in the parent README;
`key_vault` adopts the retained vault after its later approved move/state handoff.
Existing Key Vault/token ownership stays in the legacy stack during coexistence;
the new identity references that retained vault.

The primary resource is `azurerm_resource_group.main`. The single
`resource_group` output exposes the complete resource object; callers can select
`.id`, `.name`, `.location` or `.tags` from it. This root is unapplied, so the
address/output correction requires no state migration.

The adjacent [terraform.backend.tf](terraform.backend.tf) defines its complete
literal Azure backend and distinct key in `personalcorestatefile/statefiles`.
This root remains uninitialized and undeployed. Do not point it at the old
combined workload state or copy that state into multiple destinations.

Only `terraform validate` is authorized in Phase 1.
