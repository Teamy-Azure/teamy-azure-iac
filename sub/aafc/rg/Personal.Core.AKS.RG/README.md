# Personal AKS sibling roots

Core AKS foundation completed on 18 October 2026. The RG and AKS roots applied
their exact reviewed saved plans; runtime and state verification passed. Benthic
and its workloads remain running. Every directory is an independent root with a
separate Personal state key. `resource_group/` is the single owner of `Personal.Core.AKS.RG`;
components consume it. Direct Traefik ingress also completed on 18 October.
Cert-manager is now deployed with component/startup/self-signed checks passed;
its final no-change plan and state-custody verification passed.
Workloads live under `Personal.Workload.AKS.*.RG`. Hello's RG/runtime are now
deployed; its storage adoption and the other applications remain future work.

| Root | Ownership and inputs |
| --- | --- |
| `resource_group/` | Normal Core RG only. |
| `aks/` | New `Personal-AKS`, control-plane identity, subnet grant and fixed retained admin group. Settings are literals; current operator IPv4 is discovered. No input variables. |
| `ingress/` | Direct Kubernetes resources for Traefik and its LoadBalancer, including vendored CRDs; private kubeconfig path, fixed Personal-AKS context. |
| `cert_manager/` | Direct cert-manager Kubernetes resources from the official release, retained CRDs and workload identity pod label. Workload roots own their Issuers. |

State keys are `resource-groups/Personal.Core.AKS.RG/<root>.tfstate`. There is no
umbrella apply, implicit cross-root orchestration or backend state download in
these component configurations.
All 4 Core AKS roots have complete literal Entra/Azure CLI backends in
`terraform.backend.tf`, targeting `personalcorestatefile/statefiles` with distinct
keys. All 4 are initialized and deployed. NGINX hello's 3 roots belong to its
separate workload group; 2 are deployed and storage adoption remains
uninitialized. The source split and later workload deployment do not change
these 4 Core state keys. Protected
plans, backups and evidence use `ignore/deployments/Personal.Core.AKS.RG`.
No Benthic state is copied, imported or repointed at the new cluster.

## Cluster specification

The candidate uses the existing Personal VNet lookup, `AKSSubnet` in
`10.204.0.0/16`, with Azure CNI Overlay. Reserve `10.242.0.0/16` for pods and
`10.243.0.0/16` for Services (DNS `10.243.0.10`). These ranges do not overlap
either partition's VNet; include them in future peering/address reviews.
The standard LoadBalancer provides explicit managed outbound connectivity.

The source pins AKS `1.35.8`, confirmed available in Canada Central during the
18 October preflight. Both pool and control plane use that patch. Ubuntu
node images, NodeImage updates, Blob/Disk/File CSI and snapshot controller are
explicit. This preserves the Blob CSI capability without copying the obsolete
1.29/kubenet declaration. The source selects one `Standard_D4s_v5` system node,
listed without SKU restrictions in the 18 October preflight. Regional usage was
6 of 20 vCPUs and DSv5 usage was 0 of 20, sufficient for the 4-vCPU node and
another 4-vCPU surge node. The single node is not an availability guarantee.

The existing Entra admin group ID is a verified literal; the operator's membership
was confirmed at preflight. Membership is not recreated. Azure RBAC grants
cluster-admin to it. Local accounts and run-command
are disabled. The HTTPS IP data source discovers the current manual operator's
IPv4 and authorizes its /32; a data postcondition rejects invalid responses.
Neither the IP nor an operator-CIDR variable is committed.
Dedicated private Entra/kubelogin credentials were verified against the new
endpoint and node RG; the global context remains Benthic. No credentials are
written or returned by this source. Every Kubernetes
provider selects the literal Personal-AKS context. Verify the actual server/
resource ID; a context name alone does not establish which cluster it references.

AKS creates `Personal.Core.AKS.Nodes.RG` itself. Do not pre-create that group,
declare it in another state, or move resources into it. Hello storage adoption
belongs to `Personal.Workload.AKS.NGINX-Hello.RG`, outside Core and the node group.

## Maintained ingress transition

Traefik replaces the retired ingress-nginx controller on the candidate. The
18 October source rewrite uses direct Kubernetes resources: 8 typed objects and
10 vendored CRDs, with MIT/checksum metadata and an official digest-pinned
Traefik `v3.7.14` image. Kubernetes provider `3.0.1` manages the objects; there is
no ingress Helm release. The separately authorized ingress deployment completed
on 18 October 2026; hello's later workload deployment also passed acceptance.

The source waits for CRDs to report Established before starting the controller.
Azure's node `/healthz` probe is separate from the Traefik Pod `/ping` probes.
Future updates review explicit resources, image and CRD pins rather than a Helm
chart upgrade. Cert-manager now has separate direct Kubernetes source pinned to
`v1.21.2`, and is deployed.

Its 47 official static-release objects plus 4 direct startup admission-check
resources total 51: 45 typed built-ins and 6 guarded CRDs. Kubernetes provider
3.0.1 manages them; all 5 images are pinned by verified digest. Workload identity,
ambient credential flags and namespace/ServiceAccount outputs are preserved.
Dynamic webhook CA material remains controller-owned. Independent review,
recursive reflow and validation passed, then the authorized deployment added all
51 objects with none changed or destroyed. Its 3 components and startup API-check
Job passed. An isolated self-signed probe produced a Ready Issuer/Certificate
and Approved/Ready request at revision 1; its namespace was fully removed without
Secret reads or public DNS/CA use. Detailed runtime checks passed and its final
plan returned exit 0 with no changes; state-custody verification passed. Its
51-instance Azure state blob at serial 3 matches the protected pulled backup, uses a
lineage distinct from RG/AKS/ingress and has a released lease.
No Helm release, provider or installer is used. Traefik and Benthic remain unchanged.

The configuration explicitly deletes alias headers on all 3 entry points. A
reviewed 2-resource ConfigMap/checksum update rolled out successfully; refreshed
checks passed and the new log has no unset-alias-header advisory.
Encoded-path compatibility remains a future workload route acceptance check.

Traefik has one Ready/available replica, zero restarts, a verified image ID,
10 Established CRDs, non-default class and a ready EndpointSlice. RBAC checks
passed, logs showed no errors/forbidden operations and all cluster pods were
Ready. Before hello deployment, public HTTP/HTTPS returned default 404; the HTTPS
check deliberately skipped certificate validation. Hello now has a hostless HTTP
route; workload certificates remain future work.

The final ingress plan returned exit 0 with no changes. Its separate
`ingress.tfstate` has 18 instances at serial 4, a lineage distinct from RG/AKS
and a released lease. Its full Azure blob equals the protected pulled backup;
private custody remains ignored and restricted.

Traefik's Kubernetes Ingress provider handles class `traefik`. Workloads keep
their Ingress API, Services, hostnames and TLS Secret names. The separate
cert-manager root owns certificate issuance; no second ACME engine or ExternalDNS controller is
introduced. Workload NGINX containers, storage and routes remain owned by their
separate workload roots.

Read [the ingress transition](../../../../docs/ingress-transition.md) for
the HTTP/TLS/challenge checks and later cutover/rollback sequence. This source
does not install Traefik on Benthic or remove its controller.

## Core ownership and workload boundary

NGINX hello's storage adoption, content preservation, old ownership map and
Kubernetes runtime now belong to the
[hello workload README](../Personal.Workload.AKS.NGINX-Hello.RG/README.md).
The source-only split moved no Azure resources and changed no Core state keys.
Hello's later RG/runtime deployment added fresh objects and separate states,
without adopting or moving its retained storage account.

| Legacy address in `teamdman.tfstate` | Target/disposition |
| --- | --- |
| `module.benthic_cluster.azurerm_kubernetes_cluster.main` | New `aks: azurerm_kubernetes_cluster.this`; do not move old Kubernetes state to the new cluster. |
| `module.benthic_cluster.azuread_group.admins` | Retained existing group IDs; preserve memberships externally until a separately reviewed identity handoff. |
| `module.ingress_nginx.helm_release.main` | New `ingress` direct Kubernetes objects on a separate cluster/state; preserve Benthic's release. |
| `module.cert_manager.helm_release.main` | New `cert_manager` direct Kubernetes objects on a separate cluster/state; preserve Benthic's release. |
| Old cluster RGs | Retain through cluster/data/traffic handoffs; no automatic teardown. |

## Later dependency order

Personal state RG -> state account -> networking RG/VNet -> Core AKS RG -> AKS ->
dedicated candidate credentials -> ingress/cert-manager -> workload RG owners ->
their runtime/identity roots -> certificate roots after CRD discovery.
Traefik CRDs/provider are enabled for per-namespace HTTPS redirect Middleware;
website routing roots also require those CRDs before their later plans.
Persistent-resource moves/adoption have their own writer-freeze and zero-change
checks. They are distinct from new cluster creation and DNS traffic cutover.

`Personal-AKS` 1.35.8 is Succeeded and Running with one Ready Standard_D4s_v5 node
and all 17 system pods healthy. CoreDNS and Blob/Disk/File CSI components and
registrations passed runtime checks; network/security readbacks passed. Both
final plans returned exit 0 with no changes. RG/AKS state blobs equal protected
backups, use distinct lineages and have released leases; serials are 2 and 6.

Benthic remains Running with one Ready node, all 24 baseline controllers preserved
and all 4 apps at 1/1. No in-subnet probe of the state-storage account has run.
Hello's 1/1 Ready frontend verified its actual read-only legacy Blob CSI mount,
pinned runtime image and identical HTTP content through its direct LoadBalancer
and Traefik. The shared controller identities, generations and Traefik address
are unchanged, as are cert-manager readiness and the default Benthic context.
The other applications, workload certificates, persistent-resource handoff and
DNS cutover remain future work.
