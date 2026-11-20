# Personal networking foundation

This root creates `Personal.Core.Networking.VNET` and its subnets inside the
existing `Personal.Core.Networking.RG`, using `10.204.0.0/16`. The Reference
Architecture's proposed `10.203.0.0/16` remains separate.

Deploy the sibling `../resource_group` root first. This root looks up that group by name; location `canadacentral`, subscription ID and tags are literals. There are no variable inputs. It does not create the group. These independent roots do not automatically deploy prerequisites.

| Subnet | CIDR | Purpose |
| --- | --- | --- |
| GatewaySubnet | 10.204.0.0/27 | Reserved gateway space |
| PrivateEndpointsSubnet | 10.204.1.0/24 | Future private endpoints; network policies disabled |
| AKSSubnet | 10.204.4.0/22 | Reserved replacement AKS nodes; Microsoft.Storage service endpoint |

This root was deployed after its RG sibling on 18 October 2026 using its exact
saved create-only plan for the VNet and 3 subnets. All resources report Succeeded
with the exact CIDRs, AKSSubnet's Microsoft.Storage endpoint and disabled
private-endpoint network policies on PrivateEndpointsSubnet. No peering was
created. Both roots' final plans returned exit 0 with no changes.

Preflight found Microsoft.Network registered and no overlap with
live VNets (`10.203.0.0/16`, `10.224.0.0/12`) or Benthic's pod/service ranges
(`10.244.0.0/16`, `10.0.0.0/16`). No existing peerings were found. Both networking
providers disable automatic registration. This root created no gateway, private
endpoints or cluster.

The complete literal Azure backend uses Entra and Azure CLI authentication with
`personalcorestatefile/statefiles`. This root's key is
`resource-groups/Personal.Core.Networking.RG/vnet.tfstate`; the RG sibling has its
own `resource_group.tfstate` key. Preflight found both keys absent. These are fresh
states, with no state migration. The 2 bootstrap roots remain local with their
recovery imports and unchanged state hashes.

Reviewed plans, state backups and verification evidence use the protected,
ignored `ignore/deployments/Personal.Core.Networking.RG` directory.

Both Azure state blobs are verified, with distinct lineages, serial 2 each and
released backend leases. Each Azure-downloaded JSON state equals its protected
Terraform-pulled backup. Acceptance evidence is in the custody directory's
`verification/live-network-acceptance.json` and `verification/state-acceptance.json`.
No imports, state moves, AKS, legacy or reference writes occurred.
