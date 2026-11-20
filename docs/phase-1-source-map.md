# Phase 1 source and ownership map

Updated: 2026-10-18. Phase 1 source is complete. The first Phase 2 bootstrap
deployed `Personal.Core.StateFile.RG/resource_group` and its `storage_account`
sibling on 16 October 2026, with independent secured local states and hash-verified
backups. The StorageV2 account
`personalcorestatefile` uses Standard_LRS in `canadacentral`. Its `statefiles`
container is private, with a container-scoped operator Storage Blob Data
Contributor grant. Entra-authenticated upload/download and finite blob lease
acquisition/release were verified on that date; the temporary probe was removed.
On 18 October 2026, the 2 Personal networking roots were deployed, RG first,
then VNet/subnets, using exact saved create-only plans for one and 4 resources.
Both final plans returned exit 0 with no changes. They use distinct new Azure
state keys, without migrating existing state. No imports or state moves ran;
Benthic and other legacy/reference resources remain unchanged. No peering was created.

The `storage_account_network_access` sibling applied its exact reviewed saved
plan on 18 October 2026 after checking the live ACL snapshot. Azure confirms
one AKSSubnet Allow rule in Succeeded state, with all non-VNet ACL fields
unchanged. Its final plan returned exit 0 with no changes.

Core AKS foundation completed on 18 October 2026. The RG and AKS roots applied
their exact reviewed saved plans; both final plans returned exit 0 with no
changes. Runtime and state verification passed. Benthic and its workloads remain
running. The subsequent direct Traefik ingress deployment completed on the same
date, with runtime and state acceptance passed. Cert-manager then deployed 51
objects with no changes or deletions. Its 3 components, startup Job and isolated
self-signed issuance probe passed; the final plan returned exit 0 with no
changes. State-custody verification passed. Workload Issuers, ACME, DNS
and retained-resource moves remain future.

NGINX hello's RG and Kubernetes siblings deployed on 18 October 2026 from exact
reviewed saved plans: one RG and 5 Kubernetes objects, with no changes or deletions.
Both final plans returned exit 0 with no changes. The frontend is 1/1 Ready with
zero restarts, verified image identity and an actual read-only Blob CSI mount.
Direct and hostless Traefik HTTP return 200 with the same body hash as Benthic's
still-running hello. Shared Traefik/cert-manager identities and readiness are
preserved. No storage move/adoption, blob write or DNS update occurred.
Both new states passed full Azure-blob/backup equality and released-lease checks.

The Personal source contains 29 independent roots. Every root has a distinct
state key. There are 7 RG owners; payload roots are siblings rather
than nested owners or modules under the RG state.
Of these roots, 2 bootstrap backends remain local and 27 Azure backends are fully
configured with literals in each root's `terraform.backend.tf`. 12 remote roots
and the 2 local bootstrap roots are deployed. The other 15 are uninitialized.
Core AKS has 4 deployed roots, hello has 2 and Stats has 3. See the
[migration plan](personal-migration.md) for the 19 November Personal-AKS
recovery and private Stats deployment.

The preceding source-only layout refactor changed no deployed state keys. At
that point, 9 roots were deployed and 20 remained uninitialized. Reflow passed
for all 4 workload trees and all 20 affected roots validated without errors.
The NGINX, SFM and Azurewebsiets storage roots retained the existing
whole-account-output warnings for `queue_properties` and `static_website`.
Root/key proof passed: 29 roots, 7 RG owners, 27 unique remote keys and no
initialized workload backend metadata. All 155 then-deployed file hashes were
unchanged, with none missing.

Before this split, the 18 October backend cleanup removed the redundant examples
and verified 26 unique, unchanged Azure keys. Reflow passed on its 6 group trees;
all then-28 roots validated with cached providers and only existing storage-object
deprecation warnings. The 8 then-deployed backend files/caches, bootstrap states,
non-backend Terraform and upstream artifacts were preserved. No initialization,
deployment, state migration or cloud mutation occurred in that cleanup.

Fixed configuration uses literals, including storage names, region, subscription,
tags, SKUs, versions, image pins and Personal-AKS context. Generated IDs use
fixed-name lookups rather than copied outputs. The 12 remaining variable
declarations are nine private kubeconfig paths, two DNS traffic-cutover targets
and Stats' staging/production ACME choice. Every RG and storage root has zero
variable inputs. See [the repository convention](../AGENTS.md).

All eleven remaining `terraform.tfvars.example` files were removed on
19 October 2026: five Stats, three SFM and three Azurewebsiets. Three Stats files
were comment-only. The eight operational-input templates were redundant with
the documented inputs; supply those through `TF_VAR_` environment variables.
No variable declaration, default, certificate policy or Terraform behavior changed.

Primary RG/storage resource and data labels use `main`. Every RG owner exports
one complete `resource_group` object; every account owner exports one complete
`storage_account` object marked sensitive. These replace separate scalar outputs;
current roots use direct lookups and have no consumers of those old output names.

| Resource group | Sibling roots |
| --- | --- |
| Personal.Core.StateFile.RG | resource_group, storage_account |
| Personal.Core.Networking.RG | resource_group, vnet, storage_account_network_access |
| Personal.Core.AKS.RG | resource_group, aks, ingress, cert_manager |
| Personal.Workload.AKS.NGINX-Hello.RG | resource_group, storage_account, kubernetes |
| Personal.Workload.AKS.SFM-Website.RG | resource_group, storage_account, dns, dns_identity, kubernetes, certificates |
| Personal.Workload.AKS.azurewebsiets.RG | resource_group, storage_account, dns, dns_identity, kubernetes, certificates |
| Personal.Workload.AKS.GitHub-README-Stats.RG | resource_group, key_vault, identity, runtime, certificate |

The AKS-managed `Personal.Core.AKS.Nodes.RG` is created by AKS, with no separate
RG root. NGINX hello now has its own workload group/source; there is still no
replacement CloudTerrastodon test-vault or AI root. The test group contains only vault `arbitraryname`
according to the read-only inventory; the user directed a later removal, not a
replacement. Verify dependencies, secret custody and deletion scope before that
separate removal. Phase 1 does not authorize any deletion.

## Root contracts and later sequencing

Every workload now uses `Personal.Workload.AKS.*.RG`. The
[hello workload README](../sub/aafc/rg/Personal.Workload.AKS.NGINX-Hello.RG/README.md)
owns its old-to-new addresses and content-preservation procedure. The 3 other
workload groups retain their sibling-root layouts under the new names. These
unused source/key changes do not move Azure objects or alter the deployed Core.

1. Bootstrap `Personal.Core.StateFile.RG/resource_group`, then its sibling
   `storage_account`, keeping their separate local states. Establish and verify
   operator/backend access before configuring the other independent backends.
   The storage root retains the deployed container-scoped Blob Data Contributor
   grant with a literal principal ID. Its resource name remains computed under
   the reflow convention; the import block retains the exact deployed assignment
   ID. Other operators require explicit permissions; caller changes must not
   replace this grant.
2. Create networking and other RGs before their Azure payload siblings. Personal
   networking completed on 18 October 2026, RG before VNet/subnets. The AKS root
   looks up Personal's existing subnet and outputs the candidate cluster
   name, OIDC issuer and identity metadata. The retained admin group and node SKU
   are literals. The current operator's IPv4 is discovered through HTTPS for the
   API /32 rule; no old cluster credentials or resolved IPs are committed.
   The access sibling follows the VNet and adds state-account access for its
   Microsoft.Storage endpoint-enabled AKSSubnet only.
3. Obtain and verify dedicated candidate credentials before Kubernetes
   roots. Install Traefik and cert-manager before planning roots that discover
   their CRDs. All providers select the literal Personal-AKS context; its name is not
   proof of the target API server.
4. Create replacement workload identities using the candidate OIDC issuer and
   actual current DNS/vault scopes. Runtimes can initially read retained storage
   and vaults in their old groups, then edit the literal group lookups after approved
   moves. Certificate roots look up the named replacement DNS identities directly.
   Static frontends pin the verified official nginx digest; Stats pins its audited
   live digest. Hello's image-pull, mounting and HTTP serving acceptance passed;
   the other applications still require their own Phase 2 acceptance.
5. Move/adopt persistent resources and change traffic only through the separate
   preservation and cutover procedures. Declarative imports are source for the
   future adoption; they have not run. Zone/account/vault imports require existing
   post-move resources. A missing source must fail adoption rather than create an
   empty replacement. Confirm no unwanted replacement or configuration changes
   in the later execution review.

Step 1 completed on 16 October 2026. The 2 independent local backends remain
local; relocation is not required or proposed. Their repository-relative paths are:

- `ignore/bootstrap/Personal.Core.StateFile.RG/resource_group.tfstate`
- `ignore/bootstrap/Personal.Core.StateFile.RG/storage_account.tfstate`

The ignored custody directory has restricted NTFS permissions. It holds saved
plans, logs and verified state backups as well as the separate local states.
Existing remote state has not been copied or relocated.
Acceptance evidence is held in
`ignore/bootstrap/Personal.Core.StateFile.RG/verification/bootstrap-acceptance.json`.
Final post-apply Terraform plans on 16 October 2026 returned no changes.

Active imports beside the bootstrap resource declarations cover the RG, account,
container and existing operator grant using fixed ARM IDs. Use these modes:

| State and Azure condition | Bootstrap handling |
| --- | --- |
| Authoritative state exists | Use that state and leave imports active. |
| Azure objects exist but authoritative state is lost | Review and apply imports, RG first, then storage. Recover bindings without claiming to restore state history. |
| Genuinely fresh Azure deployment | Comment out all 4 import blocks, retain resource blocks and check fixed-name availability. This mode requires the Azure objects to be absent. |

A fresh deployment generates a new role-assignment GUID. Refresh that import
block's ID from the new deployment before retaining or re-enabling recovery imports.

Keep one active state owner per root and preserve backups. Both bootstrap roots
retain their local configuration in `terraform.backend.tf`. Recovery may propose a firewall
change because the allowed IPv4 follows the caller; initial data-plane access
may need authorization from an already allowed network. Recovery has not been
tested live; its authorization remains source reflow and validation only.

The networking roots have literal Azure backend blocks using Entra and Azure CLI
authentication with `personalcorestatefile/statefiles`. Their keys are
`resource-groups/Personal.Core.Networking.RG/resource_group.tfstate` and
`resource-groups/Personal.Core.Networking.RG/vnet.tfstate`; the access sibling uses
`resource-groups/Personal.Core.Networking.RG/storage_account_network_access.tfstate`.
Preflight found the original 2 keys and RG absent. Plans, state backups and
evidence are protected under the ignored
`ignore/deployments/Personal.Core.Networking.RG` directory.

Networking scope is `Personal.Core.Networking.RG`,
`Personal.Core.Networking.VNET` (`10.204.0.0/16`), GatewaySubnet (`10.204.0.0/27`),
PrivateEndpointsSubnet (`10.204.1.0/24`) and AKSSubnet (`10.204.4.0/22`, with
Microsoft.Storage service endpoint). Preflight found Microsoft.Network registered
and no overlap with the live VNets (`10.203.0.0/16`, `10.224.0.0/12`) or Benthic's
pod/service ranges (`10.244.0.0/16`, `10.0.0.0/16`); no existing peerings were found.
Both networking providers disable automatic resource-provider registration.

Live verification confirms Succeeded provisioning and all declared CIDRs,
AKSSubnet's Microsoft.Storage endpoint, disabled private-endpoint network policies
on PrivateEndpointsSubnet and no peering. Both remote states have distinct
lineages, serial 2 each and released/unlocked backend leases. Each full
Azure-downloaded JSON state equals its protected Terraform-pulled backup.
Both final plans returned exit 0 with no changes; bootstrap local-state hashes
are unchanged.
Acceptance evidence is in
`ignore/deployments/Personal.Core.Networking.RG/verification/live-network-acceptance.json`
and `ignore/deployments/Personal.Core.Networking.RG/verification/state-acceptance.json`.

The access sibling tracks one `azapi_update_resource` against the existing state
account. It GETs `networkAcls` and merges AKSSubnet's Allow into the existing VNet
rules, preserving other writable ACL fields, IP rules, default Deny and bypass.
GatewaySubnet and PrivateEndpointsSubnet receive no access. It creates no
account, role assignment or subnet, and adds no second AzureRM whole-ACL owner
or import. The new root grants no blob RBAC; no in-subnet test of state-account
access has run.

Bootstrap delegates only `network_rules[0].virtual_network_subnet_ids` through
selective ignore. Serialize bootstrap ACL maintenance and access-root updates
across their different state keys; replan stale ACL snapshots. Removing the
updater does not revoke its rule; revocation requires an explicit future patch.

Access verification confirms unchanged operator-IP rules, default Deny and
bypass None. The new remote state contains one AzAPI updater at serial 2;
Azure-downloaded JSON equals its protected Terraform-pulled backup. Entra blob
access continues and the backend lease is released. Bootstrap's verification
plan has zero managed-resource changes and only a sensitive account-output
refresh, which was not applied; both local-state hashes remain unchanged.
No RBAC or other resource changes occurred in that ACL update. VNet access was
not tested during ACL verification; no in-subnet probe of the state account has
run since. Hello's later successful CSI mount uses its separate legacy account.

Protected evidence is under
`ignore/deployments/Personal.Core.Networking.RG/storage_account_network_access/verification/`:
`live-acl-acceptance.json`, `access-acceptance.json` and
`bootstrap-delegation-review.json`.

## Core AKS and ingress deployment

The RG and AKS roots use literal Entra/Azure CLI backends in
`personalcorestatefile/statefiles`, with separate new keys
`resource-groups/Personal.Core.AKS.RG/resource_group.tfstate` and
`resource-groups/Personal.Core.AKS.RG/aks.tfstate`. Protected plans, backups and
evidence use `ignore/deployments/Personal.Core.AKS.RG`. No legacy state is copied
or imported. AKS owns creation of `Personal.Core.AKS.Nodes.RG`.

The cluster root manages 4 resources: control-plane identity, its subnet
Network Contributor grant, `Personal-AKS` and the existing admin group's cluster
RBAC grant. Preflight confirmed AKS 1.35.8 in Canada Central, unrestricted
Standard_D4s_v5 availability, sufficient regional/DSv5 quota for one node plus
surge, and operator membership in the admin group. Benthic's read-only baseline
showed one Ready node and 24 controllers, including all 4 apps at 1/1. The RG and
AKS-managed node RG were absent at preflight. Automatic provider registration is
disabled. The RG and cluster were applied from exact reviewed saved plans;
both final plans returned exit 0 with no changes.

Azure confirms `Personal-AKS` 1.35.8 is Succeeded and Running. Its one
Standard_D4s_v5 node is Ready, all 17 system pods are healthy, and CoreDNS plus
Blob/Disk/File CSI components and registrations were verified. Network/security
readbacks passed, including disabled local accounts and run-command. Dedicated
private kubeconfig endpoint and node-RG checks passed; the global context remains
Benthic. Benthic remains Running with one Ready node, all 24 baseline controllers
preserved and its 4 apps at 1/1.

Full Azure state blobs equal their protected Terraform-pulled backups. The RG
state has one managed resource at serial 2; AKS has 4 at serial 6. Lineages are
distinct and both blob leases are released. Private custody is ignored and
restricted by NTFS permissions to the operator, SYSTEM and local Administrators.

Ingress manages 18 Kubernetes objects: 8 typed namespace, identity,
RBAC, class, configuration, Deployment and Service resources, plus 10 vendored
CRDs. It uses Kubernetes provider 3.0.1, a digest-pinned Traefik v3.7.14 image and
MIT/checksum metadata for the upstream schemas. CRDs must report Established;
Azure node `/healthz` probes and Traefik Pod `/ping` probes remain distinct.
The root was deployed on 18 October 2026. Traefik has one Ready/available replica
with zero restarts, a verified image ID, all 10 CRDs Established, an explicit
non-default class and a ready EndpointSlice. Required watches/status updates
passed RBAC checks; secret deletion and role-binding creation were denied.
Controller logs had no errors or forbidden operations, and all cluster pods were
Ready. Before hello deployment, public 80/443 returned the default 404; HTTPS
testing deliberately skipped certificate validation. Workload certificates are
not installed; hello's later HTTP route is described below.
The startup alias-header advisory led to explicit deletion on all 3 entry points.
A reviewed plan applied only 2 in-place ConfigMap/checksum-rollout updates;
refreshed readiness, RBAC, image and 80/443 checks passed. The new controller log
has no unset-alias-header advisory. Encoded-path compatibility remains a future
workload route acceptance check.

Its literal Entra/Azure CLI backend uses the separate key
`resource-groups/Personal.Core.AKS.RG/ingress.tfstate` in
`personalcorestatefile/statefiles`. The final plan returned exit 0 with no
changes. Its 18-instance state is serial 4 with a lineage distinct from Core RG/AKS
and a released lease; the full Azure blob equals its protected pulled backup.
Private custody remains ignored and restricted. Benthic remains Running with
one Ready node, all 24 baseline controllers and its 4 apps at 1/1; the default
context is unchanged.
Updates now review explicit resources, image and CRD pins rather than a Helm
chart upgrade. Cert-manager now has separate direct Kubernetes source. See the
[ingress transition](ingress-transition.md) for the full source contract.

Cert-manager uses Kubernetes provider 3.0.1 with the
official v1.21.2 release manifests: 41 typed built-in objects and 6 CRDs, plus
4 direct admission-startup-check resources. The total is 51 objects: 45 typed
resources and 6 CRDs. Controller, cainjector, webhook, ACME solver and startupcheck
images are pinned by verified digest. The controller's workload-identity label,
ambient credential flags and namespace/ServiceAccount outputs are preserved.

CRDs have destruction guards and wait for Established. The dynamic webhook CA
Secret and injected CA bundles remain controller-owned; typed webhook resources
ignore only their injected CA bundles. The tracked startup API-check Job waits
for admission trust/completion and reruns after relevant resource changes.
No Helm release, provider or installer remains in this candidate root; Benthic's
historical Helm addresses remain migration provenance. Independent review,
recursive reflow and validation passed. The separately authorized deployment
added all 51 objects, with none changed or destroyed. All 3 components and the
startup Job passed. An isolated self-signed Issuer and Certificate became Ready;
the request was Approved and Ready at revision 1. The owned test namespace was
fully removed, with no Secret reads or public DNS/CA use.

Both admission webhooks now explicitly mirror AKS's observed namespace exclusions:
`control-plane NotIn true` and `kubernetes.azure.com/managedby NotIn aks`.
Existing disable-validation exclusions and CA-bundle-only ignore remain intact.
Reflow and validation passed after this source correction; the final plan
returned exit 0 with no changes; no apply was needed after matching those live
selectors in source. State-custody verification passed.
All 3 Deployments are 1/1, all 6 CRDs are Established, the Job is Complete and
the injected CA bundles are populated, valid and equal. All 9 service-account
RBAC checks passed, including denials. Workload-identity projection and tenant
checks passed; the empty controller client ID is expected for per-Issuer selection.
Cert-manager pods had zero restarts and all Personal pods were Ready or Completed.
Immediately after probe cleanup, no Issuer, Certificate, CertificateRequest or
Ingress remained. Traefik Deployment/Service identities, generations and public
address were unchanged; HTTP/HTTPS returned default 404, with HTTPS certificate
validation skipped for that listener check. Benthic is Running with one Ready node,
all 24 baseline controllers and its 4 apps ready; the global context is unchanged.
Its literal backend uses its own `cert_manager.tfstate` key. No workload Issuer,
ACME, DNS, resource move or Benthic change was included.

The complete pulled state JSON equals its direct Entra-authenticated Azure blob
download. It contains the exact planned addresses: 46 managed blocks and 51
instances at serial 3. Its lineage differs from Core RG, AKS and ingress; its
lease is released/unlocked and the ETag is stable. Private state, credentials
and evidence are ignored and restricted to the operator, SYSTEM and local
Administrators.

## Hello deployment and overlap acceptance

On 18 October 2026, `Personal.Workload.AKS.NGINX-Hello.RG/resource_group` and
then `kubernetes` applied their exact reviewed saved plans: one RG and 5
Kubernetes objects, with no changes or deletions. Both final plans returned exit
0 with no changes. The frontend is 1/1 Ready with zero restarts, a verified pinned
runtime image and an actual read-only Blob CSI mount of retained `webcontent`.
The new direct LoadBalancer and hostless Traefik route return HTTP 200 with the
same 84-byte body/hash as Benthic. HTTPS returned 404 with certificate validation
skipped; trusted workload TLS is not established.

The Ingress publishes Traefik's shared address. Traefik Deployment/Service UIDs,
generations and address are preserved, as are all 3 cert-manager Deployment
UIDs/generations and readiness. Benthic remains Running with one Ready node,
all 24 controllers and 4 apps ready; its original hello still serves identical
content and the global context remains Benthic.

No retained storage account/container metadata, blob content or DNS changed.
The account remains in its legacy RG; the adoption sibling is uninitialized.
The new keys are
`resource-groups/Personal.Workload.AKS.NGINX-Hello.RG/resource_group.tfstate` and
`resource-groups/Personal.Workload.AKS.NGINX-Hello.RG/kubernetes.tfstate`.
RG state has one managed instance at serial 2; Kubernetes has 5 at serial 3.
Complete pulled JSON equals each direct Entra-authenticated blob download,
with exact reviewed addresses, stable ETags and released leases. Both lineages
differ from one another and all 4 Core states. Private evidence and backups use
the restricted, ignored
`ignore/deployments/Personal.Workload.AKS.NGINX-Hello.RG` directory, including
`verification/runtime-acceptance.json`, `retained-storage-acceptance.json` and
`state-custody-summary.json`.

## Data and state boundaries

| Existing object | Phase 1 disposition |
| --- | --- |
| Benthic AKS, ingress-nginx and Kubernetes objects | Keep serving; fresh objects on Personal AKS use fresh independent states. Never repoint old Kubernetes state at the new API server. |
| Hello, SFM and Azurewebsiets Blob accounts/containers | Move/adopt the originals after inventory/backup; preserve every blob. New Terraform does not upload source index.html over live content. |
| Legacy Terraform-managed website blobs | Deliberate ownership release without deleting their cloud objects; publication/restore custody is external. SFM's upload-static.ps1 remains a separate content operation. |
| Azurewebsiets and SFM DNS zones | Original zone/record adoption; preserve assigned nameservers, unlisted records, TTLs and old traffic targets through the RG move. Required traffic inputs decouple later cutover. |
| Existing certificate identities | Keep old trust/grants until drained; new identities trust Personal OIDC. Reconcile scope IDs and active old solver RGs when zones move. |
| Stats vault and github-token | Retain during overlap. The legacy Terraform root rotates the secret using 1Password. The future vault move needs a reviewed transfer to a single destination Terraform secret owner, preserving existing versions. |
| Legacy combined states | Preserve/freeze during each explicit handoff. Split ownership by exact object IDs/addresses, never copy a whole combined state into several sibling keys. |

Each group's README contains the legacy-to-target address map and its narrower
preservation procedure. Import blocks do not by themselves prevent two states
from owning one object: freezing and reconciling the old owner is mandatory.
`prevent_destroy` protects managed declarations while present; it is not a backup
or a defense against deleting an entire configuration.

Reference transition source is in the separate `Reference-Architecture`
repository under
`AzureDevOps/Projects/MyCoreProject/Repos/Infrastructure/bootstrap/transition/`.
Its candidate VMSS/pool, four-account access bridge, exact state/marker manifest
and offline consumer-source generator preserve the active source and pool.
The later backend copy, queue switch and retirement remain separate operations.

## Source verification and its limits

The Phase 1 workflow is recursive Cloud Terrastodon reflow followed by
`terraform validate` using cached provider packages. No `init`, `fmt`, `plan`,
`apply`, import/state command, pipeline publication or cloud mutation is part of
Phase 1. Validation evidence is recorded in the living migration plan.

The limited Phase 2 bootstrap execution completed on 16 October 2026. Its recovery
source remains untested live. Networking execution and verification completed on
18 October 2026 for its 2 roots using fresh remote states. This did not include
AKS, peering, imports, state migration or reference networking/agent changes.
The subsequent subnet-access updater also completed on 18 October 2026, with
unchanged non-VNet ACLs and no managed-resource changes in bootstrap's review.
Core AKS foundation, runtime and state verification also completed on 18 October
2026. This slice excluded ingress installation, workloads, DNS cutover, resource
moves and Benthic changes.
The separately authorized direct ingress deployment then completed, including
runtime, final-plan and state checks. Cert-manager, workload deployment and DNS
cutover were not included.
Cert-manager was subsequently deployed under separate authorization. Its
components, startup admission check, isolated self-signed issuance, detailed
runtime checks, final no-change plan and state-custody verification passed.
Hello's separately authorized RG/runtime deployment then passed readiness,
read-only mounting, HTTP content parity, final no-change plans and state-custody
checks. Its retained storage handoff and DNS cutover were not included.

Static validation cannot prove Azure quota/move support, manifest behavior,
image availability, live CRD discovery, Blob CSI mounting, backend identities,
data restore, certificate renewal or HTTP behavior. Remaining workload/data
checks require separate execution authorization. Stats HTTP01 also requires a deliberate public
DNS/certificate transition; a pending pre-cutover certificate is not acceptance.
