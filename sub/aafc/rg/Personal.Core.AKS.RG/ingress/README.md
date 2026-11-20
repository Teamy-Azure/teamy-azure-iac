# Personal AKS ingress

Terraform manages the Kubernetes objects directly through the Kubernetes
provider. There is no Helm release, Helm provider, chart rendering or external
installer. Deployment and runtime/state acceptance completed on Personal-AKS
on 18 October 2026. Benthic and its workloads remain running.

## Objects and runtime

| Object | Purpose |
| --- | --- |
| Namespace and ServiceAccount | `traefik`; the Pod uses its in-cluster identity |
| ClusterRole and ClusterRoleBinding | Watch Services, TLS Secrets, EndpointSlices, Ingresses and Traefik custom resources; update Ingress status |
| IngressClass | `traefik`, explicitly not the cluster default |
| Ten CustomResourceDefinitions | Vendored official Traefik `v3.7.14` schemas, installed and established before the controller starts |
| ConfigMap and Deployment | Explicit configuration, one replica, `/ping` probes, JSON logs, non-root container, read-only root filesystem, dropped capabilities and RuntimeDefault seccomp |
| LoadBalancer Service | Public TCP `80`/`443` to Pod `8000`/`8443`, `externalTrafficPolicy = Local` |

The image is pinned to
`docker.io/library/traefik:v3.7.14@sha256:575fa15b135078fe5e50aa847987d96dbddd7b093c172429618404df73f3fa7c`.
This preserves the application version selected by the former chart source.
The digest identifies the official multi-platform image index and was verified
against Docker's registry on 2026-10-18.

The Kubernetes Ingress provider selects class `traefik` and copies public status
from `traefik/traefik`. The CRD provider enables namespaced Middleware references;
cross-namespace references in custom routes are disabled. ExternalName Services
are disabled in both providers. Ordinary Ingress `@kubernetescrd` annotation
references have a separate provider policy; that sender-namespace allowlist
keeps its existing default. Workload annotations refer to their own namespace.
Legacy CRD naming is explicit (`safeNaming = false`) so those hyphenated
Middleware references remain compatible. Gateway API is not enabled.
The dashboard and insecure API are disabled. The health listener on Pod port
8080 is not exposed by the Service. The Azure load balancer probes `/healthz`
on the node health-check port for the Local traffic policy; Pod probes use the
separate Traefik `/ping` listener.

The static configuration is mounted from the managed ConfigMap. Its checksum in
the Pod template rolls the Deployment when configuration changes. Writable
`/tmp` and `/data` use ephemeral volumes; cert-manager and workload TLS Secrets
own certificate persistence. Requests are `100m` CPU and `128Mi` memory, with a
`256Mi` memory limit. This small initial allocation must be checked under live
traffic before migration acceptance.

The former unapplied chart's optional Prometheus defaults are not carried over;
no metrics consumer is deployed by this source. JSON application and access logs
remain enabled.

The configuration explicitly sets `http.aliasHeadersStrategy = "delete"` on
all 3 entry points, addressing the startup alias-header advisory. A reviewed
saved plan applied only 2 in-place ConfigMap/checksum-rollout updates. Refreshed
runtime checks passed; the new log has no unset-alias-header advisory. Encoded-path
behavior retains its defaults and needs compatibility checks with the future
workload routes before cutover.

## Deployment and state

The cluster was verified first. The private `kube_config_path` selects its
dedicated credentials; the provider always uses context `Personal-AKS`.
The complete literal Azure backend uses Entra and Azure CLI authentication with
`personalcorestatefile/statefiles` and separate new key
`resource-groups/Personal.Core.AKS.RG/ingress.tfstate`. No old state was copied
or imported. The default kubeconfig context remains Benthic.

Traefik v3.7.14 has one Ready/available replica with zero restarts. Its runtime
image ID was verified against the pinned Docker index or its Linux amd64
manifest. All 10 CRDs are Established, class `traefik` is non-default and the
EndpointSlice is ready. RBAC allows the required watches/status updates and
denies secret deletion/role-binding creation. Controller logs showed no errors
or forbidden operations, and all cluster pods were Ready.

Public 80/443 returned default HTTP/HTTPS 404 responses. The HTTPS check skipped
certificate validation; workload routes and trusted certificates are not yet
installed. Cert-manager and workload deployment require separate authorization.

Read the current public address from the output rather than committing it:

```powershell
terraform -chdir=sub/aafc/rg/Personal.Core.AKS.RG/ingress output -json load_balancer_ingress
```

The final ingress plan returned exit 0 with no changes. Its remote state has 18
instances at serial 4, a lineage distinct from Core RG/AKS and a released lease.
The complete Azure blob equals its protected Terraform-pulled backup. Saved
plans, runtime/state evidence and backups are held in ignored, restricted custody
under `ignore/deployments/Personal.Core.AKS.RG`.

Benthic remains Running with one Ready node, all 24 baseline controllers
preserved and all 4 apps at 1/1. No cert-manager, workload or DNS cutover changes
were included.

Only built-in Kubernetes APIs, including `CustomResourceDefinition`, appear in
this root's Terraform resources. This avoids asking the Kubernetes provider to
discover a newly introduced Middleware kind during the same initial plan that
creates its CRD. A `depends_on` inside that same plan would not solve discovery;
finish this root before planning the dependent workload roots.

No previous Personal ingress Helm release was deployed, so this rewrite needs
no Helm uninstall, import, state move or Benthic change. The old cluster and its
workloads continue running. The `prevent_destroy` guard on the CRD resources
requires an explicit source decision before their removal because deleting a
CRD also deletes its custom objects across workload namespaces.

## Upstream source and checks

The [vendored definitions](crds/README.md) record their pinned source, license
and hashes. The RBAC rules follow the
[official versioned RBAC](https://github.com/traefik/traefik/blob/v3.7.14/docs/content/reference/dynamic-configuration/kubernetes-crd-rbac.yml),
using the supported networking API; the optional Pod `get` rule for OpenTelemetry
attributes is omitted because no OpenTelemetry exporter is configured.

`cloud_terrastodon.exe terraform reflow --recursive` and `terraform validate`
passed using Kubernetes provider `3.0.1`. Runtime acceptance is recorded above.
Application routing, certificate challenges and production-trusted TLS remain
later workload acceptance checks.
