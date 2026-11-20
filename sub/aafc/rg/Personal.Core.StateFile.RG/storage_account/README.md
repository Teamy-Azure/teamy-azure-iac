# Personal state storage

This root creates `personalcorestatefile` and its private `statefiles` container in the existing `Personal.Core.StateFile.RG`. The group name is looked up; location is the literal `canadacentral`. Group creation belongs to the sibling `resource_group` root. This root has no variable inputs.

The managed account is `azurerm_storage_account.main`. Its only output,
`storage_account`, contains the whole account object and is sensitive because
that object includes keys and connection strings. State access remains privileged.

The bootstrap order is:

1. Deploy the sibling `resource_group` root.
2. Deploy this `storage_account` root after reviewing its literals and fixed operator grant.

Both bootstrap roots were deployed on 16 October 2026. The `personalcorestatefile`
StorageV2 account uses Standard_LRS in `canadacentral`, with the private `statefiles` container and
container-scoped operator Storage Blob Data Contributor grant.

Entra-authenticated upload/download and finite blob lease acquisition/release
were verified on that date; the temporary probe was removed. Both independent
local states have secured, hash-verified backups. Acceptance evidence is held in
`ignore/bootstrap/Personal.Core.StateFile.RG/verification/bootstrap-acceptance.json`.
Final post-apply Terraform plans on that date returned no changes.

Both roots keep separate local backends. Relocation is not required or proposed.
The actual state paths, relative to the repository, are:

- `ignore/bootstrap/Personal.Core.StateFile.RG/resource_group.tfstate`
- `ignore/bootstrap/Personal.Core.StateFile.RG/storage_account.tfstate`

The ignored custody directory has restricted NTFS permissions and also holds
saved plans, execution logs and verified state backups. Preserve both states
securely. Do not share a local state path between these roots.

The fixed name `personalcorestatefile` was available in the bootstrap preflight
on 2026-10-16. Existing state accounts remain in service. This root does not copy
or adopt existing state.

The firewall denies access by default and discovers the current operator's public IPv4 through the HTTPS data source during deployment. A postcondition rejects invalid/non-IPv4 responses. No resolved address is committed. Public network access permits this allowlist; the container is private. Storage and container have `prevent_destroy`; the sibling protects the group.

The networking sibling `storage_account_network_access` added Personal
AKSSubnet's VNet Allow rule on 18 October 2026. Its exact reviewed saved plan
was applied after checking the live ACL snapshot. Azure confirms the rule is
Succeeded and all non-VNet ACL fields, including IP rules, default Deny and
bypass None, are unchanged.
This bootstrap root delegates only the subnet-ID list through
`ignore_changes = [network_rules[0].virtual_network_subnet_ids]`. It retains the
inline default-deny policy, operator IP, bypass and remaining policy fields.
The access sibling reads and preserves those fields while merging the subnet
rule; it does not create a second account or AzureRM whole-ACL owner.

Serialize ACL maintenance in these 2 roots despite their separate state locks.
Replan an access update after any concurrent ACL change. Only AKSSubnet has the
required Microsoft.Storage endpoint; the gateway/private-endpoint subnets get no
allow rule. This network rule grants no blob RBAC. Removing the updater does
not revoke the rule; revocation requires an explicit future ACL patch.

The access root's final plan returned exit 0 with no changes. This bootstrap
root's verification plan has zero managed-resource changes and only a sensitive
account-object output refresh pending; it was not applied. Both bootstrap local
state hashes are unchanged. Entra blob access continues. No RBAC changed, and
access from inside the VNet has not been tested.
Protected acceptance and delegation-review evidence is under
`ignore/deployments/Personal.Core.Networking.RG/storage_account_network_access/verification/`.

The container-scoped Storage Blob Data Contributor grant pins its deployed
principal ID as a literal. Its resource name remains computed under the reflow
convention; the import block retains the exact deployed assignment ID. The grant
does not follow the caller.
Different operators need explicit permissions; management-plane access alone does
not grant blob access. The firewall still follows the current caller's IPv4, so
recovery may propose a firewall change. Initial data-plane access may require
authorization from an already allowed network.

Active imports beside `azurerm_storage_account.main`,
`azurerm_storage_container.statefiles` and
`azurerm_role_assignment.operator_state_writer` record their deployed ARM IDs.
Use these modes:

| Mode | Action |
| --- | --- |
| Authoritative state exists | Use that state and leave all imports active. |
| Azure objects exist but authoritative state is lost | Review and apply the RG import first, then this sibling's 3 imports. These recover bindings, not state history. |
| Genuinely fresh Azure deployment | Comment out all 4 bootstrap imports, including the RG import, and retain the resource blocks. Confirm the Azure objects are absent and check fixed-name availability before reviewing creation. |

A fresh deployment generates a new role-assignment GUID. Refresh that import
block's ID from the new deployment before retaining or re-enabling recovery imports.

Keep one active state owner per root and preserve backups. Do not comment out
imports to treat existing Azure objects as a fresh deployment. The adjacent
[terraform.backend.tf](terraform.backend.tf) retains this root's local backend.

Recovery has not been tested live. Its scope remains source reflow and validation
only. The separate subnet-access deployment does not authorize executing recovery
imports or changing either bootstrap backend.
