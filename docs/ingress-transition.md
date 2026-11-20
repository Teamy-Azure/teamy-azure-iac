# Traefik transition on the replacement cluster

Updated: 2026-10-18. Traefik is deployed through direct Kubernetes Terraform
resources on Personal-AKS. Its separate deployment and runtime/state acceptance
are complete. Cert-manager is now deployed and its startup/self-signed checks
passed, with a final no-change plan and verified state custody.
Benthic and its workloads
remain running. Workload Issuers/certificates, ACME and DNS cutover remain future.
Hello now serves identical retained content over direct and Traefik HTTP; its
storage adoption remains separate.

Workload source now lives under `Personal.Workload.AKS.*.RG`, while the shared
controllers remain in Core AKS. NGINX hello has a separate
[workload group](../sub/aafc/rg/Personal.Workload.AKS.NGINX-Hello.RG/README.md)
with RG, storage and Kubernetes siblings. The source-only split moved no retained
Azure resources or controller state keys. Its subsequent RG/runtime deployment
created fresh objects; the storage root remains uninitialized.

Traefik is the maintained controller selected for the Personal cluster. It fits
the current small workload set because its Kubernetes Ingress provider can keep
the existing Ingress/Service API and cert-manager certificate ownership. Gateway
API conversion is unnecessary for this migration. Kubernetes has retired the
community ingress-nginx controller; the nginx website containers remain separate
applications and are not being replaced by Traefik.

| Concern | Current Benthic | Candidate Personal AKS |
| --- | --- | --- |
| Shared edge | ingress-nginx | Direct Kubernetes resources, official Traefik `v3.7.14` image pinned by digest |
| Ingress class | nginx | traefik, explicitly selected rather than ambient default |
| Public addresses | Existing ingress and direct hello addresses | New LoadBalancer addresses; no IP reuse assumed |
| Certificates | cert-manager 1.14.5 | Direct cert-manager 1.21.2 deployed; workload Issuers and certificates not deployed |
| Website DNS01 | Existing Azure identities and old OIDC issuer | New scoped identities and Personal OIDC issuer; optional bridge trusts |
| Stats HTTP01 | Existing nginx class | Traefik class; real hostname challenge needs public traffic to candidate |
| Content and token | Existing Blob accounts and Stats vault | Same retained content and vault/token during overlap |

Personal cert-manager source now uses direct Kubernetes resources from the
official v1.21.2 static release. Its 47 upstream objects plus 4 direct startup
admission-check resources total 51: 45 typed objects and 6 guarded CRDs. All 5
images are digest-pinned. Workload identity and controller-owned webhook CA
material remain part of the source contract. Independent review, recursive
reflow and validation passed. The separate deployment added all 51 objects,
with none changed or destroyed. Its 3 components and startup Job passed. An
isolated self-signed probe confirmed Ready Issuer/Certificate and Approved/Ready
request at revision 1; the test namespace was fully removed without Secret reads
or public DNS/CA use. Its complete literal backend is in `terraform.backend.tf`.
Detailed runtime checks passed and the final plan returned exit 0 with no changes;
state-custody verification passed. Its complete Azure state blob matches the
protected pulled backup: 51 instances at serial 3, a separate lineage and a released lease.
Immediately after that probe's cleanup, no Issuer, Certificate, CertificateRequest
or Ingress remained and both Traefik listeners returned default 404. HTTPS
certificate validation was skipped for that check. Hello's later HTTP route is
described below. Traefik's Deployment/Service identities, generations and public
address remain unchanged, as does Benthic.

The candidate listens on 80/443 and exposes no dashboard route. Hello's hostless
`/` route and separate direct LoadBalancer are deployed; workload certificates
are not installed. The hello routes preserve the old contract. Host-specific
site routes must take precedence; verify the apex, wildcard and www routes,
unknown hosts, slash/path handling and error responses explicitly. Native
Traefik routing replaces nginx controller annotations; nginx application
ConfigMaps still configure the website processes themselves. Website HTTPS
Ingresses select `websecure` with TLS enabled. Separate host-specific HTTP
Ingresses on `web` attach a namespaced RedirectScheme Middleware. The HTTP01
challenge's longer path must outrank that redirect; no global redirect captures
hello or certificate traffic. The Traefik CRD provider is enabled for these
Middleware resources, so its CRDs must exist before the website routing plans.

## Direct controller ownership

The ingress sibling root owns the `traefik` namespace, ServiceAccount,
ClusterRole/binding, explicit non-default IngressClass, ten official versioned
CRD definitions, ConfigMap, Deployment and LoadBalancer Service. Terraform sends
these objects through its Kubernetes provider; no Helm chart, Helm provider,
rendering command or Helm release is involved. The former chart was only
unapplied source, so the rewrite requires no existing release or state migration.

The official `v3.7.14` image is pinned to
`sha256:575fa15b135078fe5e50aa847987d96dbddd7b093c172429618404df73f3fa7c`,
verified against Docker's registry on 2026-10-18. This keeps the previously
selected Traefik application version. The ten CRD schemas are vendored from the
same version, with their upstream license and file hashes. The root README lists
every managed object and the runtime configuration.

The controller retains one replica, HTTP/HTTPS public ports, the `traefik`
class, both Kubernetes providers, CRD cross-namespace rejection, published Service
status and JSON access logs. Readiness/liveness probes, non-root execution,
read-only root filesystem and the private health listener are explicit in the
Deployment. Static configuration changes trigger a rollout through a ConfigMap
checksum. No dashboard route, insecure API, Gateway API provider or global HTTP
redirect is enabled.

All 3 entry points explicitly set `http.aliasHeadersStrategy = "delete"` in
response to the startup advisory. A reviewed plan applied only 2 in-place
ConfigMap/checksum-rollout updates; refreshed runtime checks passed and the new
log has no unset-alias-header advisory. Encoded-path behavior keeps its defaults;
verify compatibility with each workload's routes before traffic cutover.

The CRD cross-namespace setting governs custom route references. Ordinary
Ingress `@kubernetescrd` annotations have their own sender-namespace policy;
that policy retains its prior default, and the current workloads reference
Middleware objects in their own namespace. Legacy CRD `safeNaming = false`
preserves their existing hyphenated names. The former chart's optional
Prometheus defaults are intentionally absent because no metrics consumer is
deployed here; JSON application and access logs remain explicit.

The CRD resources wait for Established before the controller starts. Middleware
instances stay in the separate workload routing roots, which must be planned
after the ingress root finishes. The Kubernetes provider needs the live custom
kind schema at plan time; a same-plan dependency on its new CRD is insufficient.
CRD destruction is guarded because Kubernetes would cascade-delete the custom
objects. Future version upgrades must review the image, all vendored CRDs and
RBAC together rather than relying on chart upgrade defaults.

## Ingress acceptance on 18 October 2026

Traefik v3.7.14 has one Ready/available replica with zero restarts. The runtime
image identity matches the pinned image index or its Linux amd64 manifest. All
10 CRDs are Established, class `traefik` is explicitly non-default and the
EndpointSlice is ready. RBAC checks allow required watches and status updates
while denying secret deletion and role-binding creation. Controller logs showed
no errors or forbidden operations; all cluster pods were Ready.

Public HTTP and HTTPS returned Traefik's default 404. The HTTPS check skipped
certificate validation and does not establish trusted workload TLS. The final
ingress plan returned exit 0 with no changes. Its separate remote state has 18
instances at serial 4, a lineage distinct from Core RG/AKS and a released lease.
The complete blob equals its protected pulled backup in restricted, ignored
custody under `ignore/deployments/Personal.Core.AKS.RG`.

Benthic remains Running with one Ready node, all 24 baseline controllers and its
4 apps at 1/1; the default context is unchanged. Read the
[ingress root README](../sub/aafc/rg/Personal.Core.AKS.RG/ingress/README.md)
for the current public address output command.

## Hello acceptance on 18 October 2026

The separate hello RG/runtime deployment added one RG and 5 Kubernetes objects,
with no changes or deletions. Both final plans returned exit 0 with no changes.
Its frontend is 1/1 Ready with zero restarts and a verified pinned runtime image.
The actual read-only Blob CSI mount uses the retained `webcontent` container.
Its new direct LoadBalancer and hostless Traefik route return HTTP 200 with the
same 84-byte body/hash as Benthic's original hello. The Ingress publishes the shared
Traefik address. HTTPS returned 404 with certificate validation skipped;
this does not establish trusted workload TLS.

Traefik Deployment/Service UIDs, generations and public address are unchanged.
All 3 cert-manager Deployments remain Ready with the same UIDs/generations.
Benthic remains Running with one Ready node, all 24 controllers and 4 apps ready;
its hello still returns the original HTTP content and the default context remains
Benthic. No retained storage, blob content, DNS or legacy state changed. The two
new states passed full blob/backup equality, distinct-lineage and released-lease
checks. See the [hello workload README](../sub/aafc/rg/Personal.Workload.AKS.NGINX-Hello.RG/README.md)
for storage handoff and evidence details.

## Remaining migration sequence

1. Review workload identity and Issuer/Certificate roots under separate execution
   authorization. The foundations, Traefik and cert-manager are deployed and
   verified; real DNS01/HTTP01 and workload TLS remain untested. Leave Benthic serving.
2. Deploy the three remaining apps against preserved data. Hello's HTTP overlap
   acceptance is complete; its storage move/adoption remains separate. Test each host using
   the candidate address directly with Host/SNI overrides. Check HTTP and HTTPS
   behavior, blob bytes, Stats token access and actual application responses.
   Verify DNS01 with staging first; staging certificates are not trusted public
   certificates. Preserve production TLS material privately if temporary reuse
   is chosen. No such secret transfer has been executed or automated here.
3. Move/adopt the original Azurewebsiets DNS zone into
   `Personal.Workload.AKS.azurewebsiets.RG`, preserving nameservers, every record
   and old traffic values. The SFM zone/storage moves into
   `Personal.Workload.AKS.SFM-Website.RG` have the
   same independent preservation checks. Repair role scopes and active old
   cert-manager solver group settings during the move so Benthic can renew.
   Moving a zone is not changing its A records to Traefik.
4. At the separately approved traffic cutover, change each site's traffic input
   or external registrar A record to the candidate LoadBalancer. Stats HTTP01
   cannot complete its real-name public challenge in advance while public DNS
   exclusively reaches Benthic; sequence certificate reuse/issuance deliberately.
   Prove production-trusted TLS and renewal, HTTP redirect behavior, apex/www/
   wildcard paths, content checksums and real Stats responses before acceptance.
5. Keep the old cluster/controller, addresses and ownership backups through the
   agreed observation period. Roll back DNS to old addresses if acceptance
   fails, retaining old data access and certificate solver permissions. Retire
   the old controller only with the old cluster after every workload, data and
   ownership handoff has passed. No uninstall on Benthic is part of Phase 1.

`terraform validate` does not pull images, query live CRDs,
test an HTTP challenge or prove the old and new controllers behave identically.
Initial ingress acceptance covered the shared controller and empty public listeners;
hello acceptance then verified its live HTTP route and retained-content mount.
The other application routes, challenges, trusted certificates and traffic cutover still
require their separate acceptance checks and authorization.

## Primary references checked

- [Kubernetes ingress-nginx retirement](https://kubernetes.io/blog/2026/01/29/ingress-nginx-statement/).
- [Traefik Kubernetes Ingress routing](https://doc.traefik.io/traefik/reference/routing-configuration/kubernetes/ingress/).
- [Pinned Traefik CRD definitions](https://github.com/traefik/traefik/blob/v3.7.14/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml) and
  [RBAC](https://github.com/traefik/traefik/blob/v3.7.14/docs/content/reference/dynamic-configuration/kubernetes-crd-rbac.yml).
- [Traefik installation without Helm](https://doc.traefik.io/traefik/v3.7/reference/install-configuration/providers/kubernetes/kubernetes-crd/#requirements).
- [cert-manager support matrix](https://cert-manager.io/docs/releases/) and
  [Azure DNS workload identity](https://cert-manager.io/docs/configuration/acme/dns01/azuredns/).
- [AKS CNI Overlay](https://learn.microsoft.com/en-us/azure/aks/azure-cni-overlay).
