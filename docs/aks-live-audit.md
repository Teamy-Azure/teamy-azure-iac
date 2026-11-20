# Benthic live migration audit

**Audit date:** 2026-10-15, America/Toronto.  
**Latest Kubernetes observation:** 2026-10-16T02:22:14Z.  
**Status:** Live workload inventory matches the expected application set; complete
configuration parity and a successful restore are not yet proven.

Phase 1 source now covers all four applications below in Personal sibling roots,
with Traefik replacing the candidate's shared ingress controller. See the
[source map](phase-1-source-map.md) and [ingress transition](ingress-transition.md).
This does not change the historical live observations or prove a deployed restore.

## Result

The fresh read-only audit found all four expected application Deployments ready
at one replica each, with their expected Services and Ingresses. No additional
application workload was found in the queried resources. The directly configured
application objects' field managers include `HashiCorp` or `Terraform`; shared
ingress/certificate resources carry the expected Helm ownership. Field ownership
supports provenance but does not prove every live field equals current source.

The subsequent ownership decision places hello's storage in `Personal.Core.AKS.RG`
with the core cluster/ingress deployment. This changes the migration target, not
the historical live inventory below; there is no separate NGINX destination RG.

| Namespace | Live application | Source owner | Observed dependencies |
| --- | --- | --- | --- |
| `nginx-hello` | `frontend`, 1/1 ready | `ca.teamdman.iac/src/modules/nginx_hello/` | Blob CSI `webcontent` mount; storage Secret; LoadBalancer Service and hostless ingress. |
| `azurewebsiets` | `frontend`, 1/1 ready | `net.azurewebsiets.iac/modules/azurewebsiets/` | Blob CSI content, NGINX ConfigMap, two DNS Issuers, TLS, apex/wildcard ingress. |
| `sfm-website` | `frontend`, 1/1 ready | `sfm-website/iac/` | Blob CSI content, NGINX ConfigMap, two DNS Issuers, TLS, apex/www ingress. |
| `teamy-github-readme-stats` | `frontend`, 1/1 ready | `teamy-github-readme-stats/platform/iac/` | Workload identity ServiceAccount, Key Vault configuration, one Issuer, TLS, host ingress. |

Shared add-ons match the legacy source: cert-manager v1.14.5 and ingress-nginx
controller v1.12.1 (the source selects chart 4.12.1). Five namespace Issuers and
three Certificates report Ready=True. These are Kubernetes status observations,
not fresh external HTTP, DNS or certificate-renewal tests.

There are no StatefulSets, Jobs, CronJobs, PVCs, PVs, HPAs or VolumeSnapshot objects
in the successful queried lists. No application init containers, image-pull
Secrets or application Role/RoleBinding objects were present. The 24 Pods belong
to the four apps and platform components; no extra Pod was present in `default`
or `aks-command`. The latter namespace is retained inspection plumbing.

Nine installed CRDs cover cert-manager (six) and CSI snapshots (three). No other
custom application API family was found in discovery. The queried system objects
include AKS components, Helm resources, standard storage classes and generated
certificate history. `coredns-custom` has no data keys. Platform RBAC, webhook and
other system configuration has not been semantically compared with a clean
replacement AKS baseline; do not treat all system objects as independent IaC to
copy blindly.

## Material findings for restoration

1. **Website bytes are a separate migration dependency.** All three NGINX apps
   mount Azure Blob `webcontent` through the Blob CSI driver. No PVC does not mean
   no persistent data. Hello and Azurewebsiets source declare `index.html` only;
   live additional files or manual edits remain unverified. SFM's
   `iac/upload-static.ps1` uploads its full static tree outside Terraform. A fresh
   empty storage account/container plus Terraform deployment will not restore
   SFM's files. Preserve existing accounts or inventory, back up and verify their
   complete content before replacing storage.
2. **Secret material and external identity must remain usable.** Storage-key
   Secrets are recreated from storage credentials, not from their names. Stats
   needs its retained Key Vault GitHub token and permissions. DNS certificate
   identities and Stats need the replacement AKS OIDC trust while old trust stays
   available during coexistence. The audit exported Secret names/types only; it
   did not retrieve their values or validate Key Vault data and Azure grants.
3. **Reproduce the running image deliberately.** Stats requests `:latest` with
   Always pull policy. Its running image ID is
   `ghcr.io/teamdman/teamy-github-readme-stats@sha256:b498d7bf7be7f32d1381ba9995b505f31e0febd489a68f1f3504ed65ff470cc2`.
   That observation is saved privately with the other image IDs; registry
   availability and a fresh pull of the intended digest are not yet tested.
4. **Platform versions need a replacement decision.** Azure reports control plane
   1.29.10; both the node-pool properties and live node report current node version
   1.28.5. Legacy source pins cluster 1.29.10. Do not assume the control-plane value
   describes the running nodes or reuse that old version as a new-cluster target
   without checking supported versions and workload/chart compatibility.
5. **Public integration still needs acceptance tests.** Keep the original
   Azurewebsiets zone and current record targets during its RG move, repair DNS
   permissions and certificate solver group settings, and retain Stats' manual
   registrar A record dependency. Prove the replacement's content, certificates,
   host routing and Stats API/Key Vault access before changing traffic or retiring
   Benthic. Generated TLS/ACME objects are runtime state; successful reissuance is
   a test requirement, not assumed from their current Ready status.

The live Azure network properties report kubenet, pod CIDR `10.244.0.0/16`,
service CIDR `10.0.0.0/16`, load-balancer outbound mode, enabled Blob CSI, OIDC and
workload identity, and one `standard_b2s` system node. The pool's subnet ID is not
specified in that response. This adds evidence to the address plan but does not
replace an inventory of the actual managed VNet, connected networks and routes.

## Evidence and limits

Read-only `kubectl get`, API discovery and `az aks show` queries were used. The
latest snapshot contains 476 sanitized objects across six query groups, plus 26
Secret metadata entries, with zero query-group failures. Fields retained include
object identity, ownership/field managers, image IDs, selected workload/routing
references, ConfigMap key names and certificate condition summaries.

The collector and snapshots are under ignored `ignore/aks-audit/`; the latest
snapshot is `20261016T022214Z/inventory.json`, with the Azure properties captured
in `cluster-properties.json`. Checkout paths vary by machine and are omitted here.
These private files are supporting evidence, not a secure full-manifest or data
backup. No Secret values, ConfigMap values, environment values, complete
annotations, Helm values, Pod logs or container files were exported. Keep
evidence private and take a fresh snapshot immediately before the later cutover.

This audit compares object inventory and selected fields to source inspection;
it does not evaluate the old Terraform state or prove full desired/live field
equality. In particular, Helm values, all RBAC rules, literal environment/config
values, blob contents, registry availability, external Azure permissions and an
actual replacement deployment remain unverified.

The August rebuild notes contained only a historical partial inventory, with the
complete frozen evidence/data tasks still unchecked. This fresh observation
supersedes that older presence evidence, not the outstanding data/restore gates.

No Terraform command, cluster mutation, remote execution, pipeline run, state
operation, DNS change or secret export occurred during this audit.
