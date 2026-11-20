# Personal Azure infrastructure

This repository is the home for manually deployed Personal infrastructure. The
Azure DevOps reference deployment belongs to the separate
`Reference-Architecture` repository, including its own state bootstrap and
networking. AKS and the personal websites stay here.

Core resource groups use `Personal.Core.<Purpose>.RG`. Cluster-hosted workloads
use `Personal.Workload.AKS.<Workload>.RG`. Hyphens remain inside names such as
`SFM-Website`; `azurewebsiets` deliberately matches the existing domain/workload.

Minimize indirection: these roots describe one concrete deployment. Resource
names, storage names, regions, subscriptions, tags, versions, SKUs and image pins
belong directly in source. Generated IDs use fixed-name data lookups. The
[repository convention](AGENTS.md) records this rule for future changes.

| Personal boundary | Source scope |
| --- | --- |
| `Personal.Core.StateFile.RG` | Initial state storage and private `statefiles` container. |
| `Personal.Core.Networking.RG` | Independent `10.204.0.0/16` VNet, reserved subnets and state-account subnet access. |
| `Personal.Core.AKS.RG` | Deployed AKS, Traefik and cert-manager platform. |
| `Personal.Workload.AKS.NGINX-Hello.RG` | Separate RG owner, retained hello storage adoption and Kubernetes runtime. |
| `Personal.Workload.AKS.SFM-Website.RG` | Retained storage/DNS adoption, replacement identity, website and DNS01 certificates. |
| `Personal.Workload.AKS.azurewebsiets.RG` | Existing `azurewebsiets.net` zone/storage adoption, identity, website and DNS01 certificates. |
| `Personal.Workload.AKS.GitHub-README-Stats.RG` | Protected vault adoption, replacement identity, pinned Stats runtime and HTTP01/TLS routing. |

Each directory with Terraform files is an independent root, with its own state
lifecycle. New roots sit below `sub/aafc/rg/<resource-group>/`. There is no umbrella
apply or Personal deployment pipeline.

Every group has a `resource_group/` root that creates only the group. Components
live in sibling roots and look up that existing group:

```text
sub/aafc/rg/
  Personal.Core.StateFile.RG/
    resource_group/
    storage_account/
  Personal.Core.Networking.RG/
    resource_group/
    vnet/
    storage_account_network_access/
```

The same separation applies to AKS and workload components: their
`resource_group/` root remains the single group owner, and each component root
that manages Azure resources reads it through an Azure resource-group data source.
Kubernetes roots use explicit candidate-cluster credentials. Deploy the group first;
separate roots do not automatically orchestrate one another.

NGINX hello now has separate workload source in
`Personal.Workload.AKS.NGINX-Hello.RG`, with `resource_group/`, `storage_account/`
and `kubernetes/` siblings. Core AKS contains only its 4 deployed platform roots.
The [hello workload handoff](sub/aafc/rg/Personal.Workload.AKS.NGINX-Hello.RG/README.md)
owns storage preservation/adoption and runtime instructions. The existing Azure
account remains in its legacy group until a separately authorized move.

The legacy `Teamy-Infrastructure-as-Code-RG` and `TEAMY-NETWORK-RG` roots remain
unchanged while their consumers are separated. Their presence here does not mean
the new Personal configuration has adopted them. The old network still supports
the reference deployment's agents.

## Migration status

Phase 1 source is complete. The user authorized the first Phase 2 bootstrap:
`Personal.Core.StateFile.RG/resource_group`, followed by its `storage_account`
sibling. Both roots are deployed. The `personalcorestatefile` StorageV2 account
uses Standard_LRS in `canadacentral`, with a private `statefiles` container and
a container-scoped operator Storage Blob Data Contributor grant.

On 16 October 2026, Entra-authenticated upload/download and finite blob lease
acquisition/release were verified. The temporary probe was removed. Both independent
local states received secured, hash-verified backups. Acceptance evidence is held in
`ignore/bootstrap/Personal.Core.StateFile.RG/verification/bootstrap-acceptance.json`.
The final post-apply plans on that date returned no changes.

On 18 October 2026, `Personal.Core.Networking.RG/resource_group` and then its
`vnet` sibling were deployed from their exact saved create-only plans: one RG,
then `Personal.Core.Networking.VNET` (`10.204.0.0/16`) and 3 subnets. All resources
report Succeeded, with the declared CIDRs, service endpoint and private-endpoint
network policies. No peering was created. Both final plans returned exit 0 with
no changes.

The new remote states in `personalcorestatefile/statefiles` have distinct
lineages, serial 2 each and released backend leases. Each Azure-downloaded state
matches its protected Terraform-pulled backup. The bootstrap local states are
hash-unchanged. No imports, state moves, AKS, legacy or reference writes occurred.

On 18 October 2026, `storage_account_network_access` applied its exact reviewed
saved plan after checking the live ACL snapshot. Azure confirms one AKSSubnet
Allow rule in Succeeded state; operator IP, default Deny, bypass None and all
other non-VNet ACL fields are unchanged. Its final plan returned exit 0 with no
changes. Blob RBAC is unchanged; access from inside the VNet has not been tested.

The bootstrap verification plan has zero managed-resource changes and only a
sensitive account-output refresh pending, which was not applied. Both local
state hashes remain unchanged. The access root's remote state is backed up and
verified against its Azure blob; its backend lease is released.

Core AKS foundation completed on 18 October 2026. The RG and `aks` sibling were
applied from exact reviewed saved plans. `Personal-AKS` 1.35.8 is Succeeded and
Running, with one Ready Standard_D4s_v5 node and all 17 system pods healthy.
CoreDNS and Blob/Disk/File CSI components and registrations were verified.
Both final plans returned exit 0 with no changes; both remote states match their
protected backups and have released leases.

Dedicated private credentials were verified against the new endpoint and node
RG; the global context remains Benthic. Benthic remains Running, with one Ready
node, all 24 baseline controllers and its 4 apps at 1/1. The other application
deployments, resource moves and DNS cutover remain future work. No in-subnet
probe of the state-storage account has run.

Traefik ingress completed on 18 October 2026: one Ready replica, all 10 CRDs
Established, verified image identity and public HTTP/HTTPS default 404 responses.
The HTTPS check skipped certificate validation; that initial acceptance preceded
workload routes and certificates. A reviewed ConfigMap/checksum rollout made alias-header
deletion explicit, and refreshed acceptance passed. Its final plan returned exit
0 with no changes, and its 18-instance remote state matches the protected backup. Benthic and the default
context remain unchanged.

Cert-manager v1.21.2 completed on 18 October 2026: 51 objects added, none changed or destroyed.
All 3 components and the startup API-check Job passed. An isolated self-signed
probe confirmed a Ready Issuer, Ready Certificate and Approved/Ready request at
revision 1; its namespace was fully removed without reading Secrets or using
public DNS/CA services. Runtime checks passed and the final plan returned exit 0
with no changes. Its complete Azure state blob matches the protected pulled
backup: 51 instances at serial 3, a distinct lineage and a released lease. No
workload Issuers, ACME configuration or DNS changes were deployed.

NGINX hello's resource group and Kubernetes sibling deployed on 18 October 2026
from reviewed saved plans: one RG, then 5 Kubernetes objects, with no changes or
deletions. Both final plans returned exit 0 with no changes. Its single frontend
is Ready with zero restarts and a verified pinned runtime image. The actual
read-only Blob CSI mount serves the retained `webcontent` data. Direct and
hostless Traefik HTTP requests return 200 with the same 84-byte body hash as Benthic.
HTTPS returned 404 with certificate validation skipped; trusted workload TLS
is not established. Traefik and cert-manager identities/readiness are preserved.
At the October deployment check, Benthic and its original hello were healthy.
The retained storage account/container and DNS were unchanged. Storage adoption
and the resource-group move have not run.
Both new remote states match their full protected backups, use separate lineages
and have released leases. The RG has one managed instance at serial 2;
Kubernetes has 5 at serial 3.

On 19 November, Azure reconciliation restored Personal-AKS following the billing
pause. Both NGINX hello routes returned the same October content. Private GitHub
README Stats now runs on Personal-AKS through a ClusterIP Service and uses the
retained vault through workload identity. See the [migration plan](docs/personal-migration.md)
for recovery and verification details.

The 29 Personal roots include the cluster, add-ons, all four audited applications
and persistent-resource adoption source beside their RG owners. Legacy remote
states, Benthic workload objects, DNS records and pipeline definitions remain unchanged.

There are two phases. Phase 1 finishes all migration Terraform, component input/
output contracts, ownership mappings and preservation procedures, with recursive
reflow and validation. Source and preservation mappings are now written; the
migration plan records their validation and remaining execution gates. Further
Phase 2 deployments require their own review and authorization. The fixed Personal
state account name is `personalcorestatefile`; operator IPv4 is discovered at
deployment time. Only private kubeconfig paths, website DNS cutover targets and
Stats' staging/production ACME choice remain variable inputs. Source validation
does not establish live restore or deployment readiness.

There are no `terraform.tfvars.example` files. Fixed values belong in source;
provide genuine operational inputs through `TF_VAR_` environment variables.
Private credential paths and reviewed traffic/certificate transitions retain
their inputs without adding redundant template files.

Traefik replaces the retired ingress-nginx controller on the candidate cluster.
It is deployed through 18 direct Kubernetes resources, including 10 vendored
CRDs, with a pinned Traefik v3.7.14 image. Cert-manager source now uses direct
Kubernetes resources from the official v1.21.2 release, with 51 objects and 5
digest-pinned images. Independent review, recursive reflow and validation passed,
followed by the separately authorized cert-manager deployment. Benthic and the
deployed Traefik remain unchanged.
The website nginx containers remain.
Read the [ingress transition](docs/ingress-transition.md)
for certificate, traffic-cutover and rollback details, and the
[Phase 1 source map](docs/phase-1-source-map.md) for root dependencies and ownership.
The CloudTerrastodon test vault is a later removal candidate, with no replacement.

Read [the migration plan](docs/personal-migration.md) for the full resource-group
inventory, ownership decisions, state keys, evidence and remaining gates. It also
records why the cluster cannot be renamed or moved in place.

The state group's `resource_group/` and `storage_account/` roots each keep a
separate local backend. Backend relocation is not required or proposed.
Their state paths, relative to the repository, are:

- `ignore/bootstrap/Personal.Core.StateFile.RG/resource_group.tfstate`
- `ignore/bootstrap/Personal.Core.StateFile.RG/storage_account.tfstate`

This ignored directory has restricted NTFS permissions and also holds saved
plans, execution logs and verified state backups. State and plans may contain
account keys; preserve this custody without publishing their contents.

The original operator's access was verified during bootstrap. Later authorized
deployments must create each remaining `resource_group/` before its sibling
components. Networking followed that order on 18 October 2026.

All 27 Personal Azure backends are fully specified as literals in each root's
`terraform.backend.tf`, using Entra and Azure CLI authentication. The 2 bootstrap
roots retain their local backends. Redundant backend example files are removed.
12 remote roots and the 2 local bootstrap roots are deployed. The other 15 are
uninitialized: hello storage adoption, Stats vault adoption and certificates,
and the 12 website roots.

Before the hello deployment, the source-only workload-layout refactor added its
RG owner and retained every deployed state key. At that point, 9 roots were
deployed and 20 remained uninitialized. Reflow passed for all 4 workload trees
and all 20 affected roots validated. The storage-account roots retained existing
whole-object-output AzureRM deprecation warnings. Root/key proof passed: 29 roots,
7 RG owners, 27 unique remote keys and no initialized workload backends. All
155 then-deployed file hashes were unchanged, with none missing.

Before this split, the 18 October backend cleanup passed recursive reflow on
6 group trees and validation on its then-28 roots. Only existing full-storage-object
AzureRM deprecation warnings remained. Its 8 then-deployed backend files/caches,
bootstrap states, non-backend Terraform and upstream files were preserved. No
initialization, deployment, state migration or cloud mutation occurred in that cleanup.

The deployed networking keys are:

- `resource-groups/Personal.Core.Networking.RG/resource_group.tfstate`
- `resource-groups/Personal.Core.Networking.RG/vnet.tfstate`
- `resource-groups/Personal.Core.Networking.RG/storage_account_network_access.tfstate`

The deployed Core AKS keys are:

- `resource-groups/Personal.Core.AKS.RG/resource_group.tfstate`
- `resource-groups/Personal.Core.AKS.RG/aks.tfstate`
- `resource-groups/Personal.Core.AKS.RG/ingress.tfstate`
- `resource-groups/Personal.Core.AKS.RG/cert_manager.tfstate`

The deployed hello workload keys are:

- `resource-groups/Personal.Workload.AKS.NGINX-Hello.RG/resource_group.tfstate`
- `resource-groups/Personal.Workload.AKS.NGINX-Hello.RG/kubernetes.tfstate`

Hello plans and verification evidence use the protected, ignored
`ignore/deployments/Personal.Workload.AKS.NGINX-Hello.RG` directory. Its storage
adoption root is uninitialized and owns no live resources.

The deployed Stats keys are:

- `resource-groups/Personal.Workload.AKS.GitHub-README-Stats.RG/resource_group.tfstate`
- `resource-groups/Personal.Workload.AKS.GitHub-README-Stats.RG/identity.tfstate`
- `resource-groups/Personal.Workload.AKS.GitHub-README-Stats.RG/runtime.tfstate`

Networking plans, state backups and verification evidence use the protected,
ignored `ignore/deployments/Personal.Core.Networking.RG` directory. Preserve both
local bootstrap states independently.
Acceptance evidence is in its `verification/live-network-acceptance.json` and
`verification/state-acceptance.json` files.

The access sibling reads the current ACL and uses an AzAPI update to merge only
AKSSubnet's Allow rule. Bootstrap ignores changes to VNet subnet IDs while
retaining ownership of the remaining policy fields. Serialize both roots' ACL
updates and replan if an ACL snapshot becomes stale. Read the
[access root instructions](sub/aafc/rg/Personal.Core.Networking.RG/storage_account_network_access/README.md)
for the ownership and revocation details.
Access-patch evidence is held under
`ignore/deployments/Personal.Core.Networking.RG/storage_account_network_access/verification/`.
Core AKS plans, backups and evidence use the protected, ignored
`ignore/deployments/Personal.Core.AKS.RG` directory. The 4 deployed Core AKS roots use fresh
states; no Benthic state is copied or imported. AKS creates its own
`Personal.Core.AKS.Nodes.RG`; do not create that group separately.

## Recover bootstrap state

Active import blocks sit beside the 4 bootstrap resource declarations and use
their fixed deployed ARM IDs. The role assignment's principal is fixed to the
existing operator. Its resource name remains computed under the reflow convention;
the import block retains the exact deployed assignment ID.

| Mode | Action |
| --- | --- |
| Existing authoritative state | Keep the import blocks active and use that state. |
| Lost state with no authoritative owner | Recover bindings through a separately reviewed import plan and apply, RG first, then storage. Imports do not restore state history. |
| Genuinely fresh Azure deployment | Only when the Azure objects do not exist, comment out all 4 import blocks and keep the resource blocks. Check fixed-name availability before reviewing creation. |

A fresh deployment generates a new role-assignment GUID. Refresh that import
block's ID from the new deployment before retaining or re-enabling recovery imports.

Keep one active state owner per root and preserve backups. Existing Azure objects
must be imported rather than treated as a fresh deployment. Different operators
need explicit permissions. The storage firewall still discovers the current
caller's IPv4, so recovery may propose a firewall change. Initial data-plane
access may require authorization from an already allowed network.

This recovery source has not been exercised against Azure. Bootstrap recovery
remains limited to source reflow and validation; the networking deployment does
not authorize imports or changes to either local bootstrap backend.

## Author and reflow source

Authoring a component in `main.tf` is fine. Run Cloud Terrastodon's recursive
reflow on each Personal group tree you change; it splits and names the Terraform
files using the repository convention. For example:

```powershell
cloud_terrastodon.exe terraform reflow --recursive sub/aafc/rg/Personal.Core.StateFile.RG
```

Then run `terraform validate` in each affected root with locally available
providers and modules. Bootstrap execution completed on 16 October 2026.
Networking execution and verification completed on 18 October 2026 for its 2
foundation roots and the additional subnet-access patch.
Core AKS deployment, runtime and state verification completed on 18 October 2026.
Direct Traefik and cert-manager deployments and acceptance also completed on that date.
Hello's RG/runtime deployment, HTTP content parity, state verification and final no-change plans
also passed on 18 October; its storage handoff and DNS cutover remain separate.
Validation alone does not prove live recovery or Azure deployment readiness for
other roots.
