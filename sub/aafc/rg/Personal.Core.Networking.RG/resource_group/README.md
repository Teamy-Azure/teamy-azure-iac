# Personal networking resource group

This root creates only `Personal.Core.Networking.RG`. It owns the group's location, tags and deletion protection.

Deploy this root before the sibling `../vnet` root. The VNet root looks up the existing group by name. Location `canadacentral`, subscription ID and tags are literals in both roots; neither has variable inputs. The independent roots do not automatically deploy the group.

This root and then its VNet sibling were deployed on 18 October 2026 from exact
saved create-only plans: one RG, then one VNet and 3 subnets. All resources report
Succeeded with the declared CIDRs, service endpoint and private-endpoint network
policies, and no peering. Both final plans returned exit 0 with no changes.

Preflight found the RG and both new state keys absent, with
Microsoft.Network registered. Both providers disable automatic registration.

The complete literal Azure backend uses Entra and Azure CLI authentication with
`personalcorestatefile/statefiles`. This root's key is
`resource-groups/Personal.Core.Networking.RG/resource_group.tfstate`; the VNet uses
its separate `vnet.tfstate` key. These are fresh states, with no state migration.
The 2 bootstrap roots keep their independent local states and recovery imports;
their state hashes are unchanged.

Reviewed plans, state backups and verification evidence use the protected,
ignored `ignore/deployments/Personal.Core.Networking.RG` directory.

Both Azure state blobs are verified, with distinct lineages, serial 2 each and
released backend leases. Each Azure-downloaded JSON state equals its protected
Terraform-pulled backup. Acceptance evidence is in the custody directory's
`verification/live-network-acceptance.json` and `verification/state-acceptance.json`.
No imports, state moves, AKS, legacy or reference writes occurred.
