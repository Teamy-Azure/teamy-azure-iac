# Personal state account subnet access

This sibling adds Personal AKSSubnet's VNet Allow rule to `personalcorestatefile`.
Its exact reviewed saved plan was applied on 18 October 2026 after checking the
live ACL snapshot. Azure confirms one AKSSubnet Allow rule in Succeeded state,
with all non-VNet ACL fields unchanged. The networking VNet/subnets exist.

Terraform tracks one `azapi_update_resource.statefile_vnet_access` against the
existing account. The root GETs the current `networkAcls` and merges AKSSubnet's
Allow into its VNet rules. It preserves other writable ACL fields and rules,
including operator IP access, default Deny and bypass. Read-only VNet-rule
provisioning state is omitted from the update.

Only AKSSubnet has the required Microsoft.Storage service endpoint. The root
checks this prerequisite and default Deny before updating. It grants no access
to GatewaySubnet or PrivateEndpointsSubnet, creates no account/role/subnet and
adds no second AzureRM whole-ACL owner or import.

Bootstrap retains the account, operator-IP and other policy settings. It ignores
only `network_rules[0].virtual_network_subnet_ids`, allowing this sibling to
maintain that list. Serialize bootstrap ACL maintenance and access-root updates:
their different state keys do not provide a shared lock. Replan after any ACL
change so the merged snapshot preserves current rules.

The complete literal backend uses Entra and Azure CLI authentication with
`personalcorestatefile/statefiles`, under
`resource-groups/Personal.Core.Networking.RG/storage_account_network_access.tfstate`.
This is a separate fresh state, without migrating bootstrap or networking state.

The final plan returned exit 0 with no changes. The remote state contains one
AzAPI updater at serial 2. Its Azure-downloaded JSON equals the protected
Terraform-pulled backup, Entra blob access continues and its backend lease is
released. The bootstrap verification plan has zero managed-resource changes;
only its sensitive whole-account output would refresh, and that was not applied.
Both bootstrap local-state hashes are unchanged.

Acceptance evidence is protected under
`ignore/deployments/Personal.Core.Networking.RG/storage_account_network_access/verification/`:
`live-acl-acceptance.json`, `access-acceptance.json` and
`bootstrap-delegation-review.json`.

The updater has `prevent_destroy`. Removing it through a future approved change
does not undo the Azure patch; revoking the allow rule needs an explicit ACL
update. No RBAC or other resource changes occurred. Network admission grants no
blob identity permissions. VNet access was not tested during ACL verification;
no in-subnet storage probe has run since.
