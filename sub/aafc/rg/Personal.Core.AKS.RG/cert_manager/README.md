# Personal AKS cert-manager

Terraform directly manages cert-manager `v1.21.2` through the Kubernetes provider.
This root has no Helm release, chart renderer, module, command installer or Helm
provider. It is deployed on Personal-AKS; component/startup/self-signed checks
passed, along with detailed runtime checks and the final no-change plan.
State-custody verification passed. The only input is the private kubeconfig
path; provider context is fixed to `Personal-AKS`.

## Managed objects

| Kubernetes objects | Count | Purpose |
| --- | ---: | --- |
| Namespace and ServiceAccounts | 5 | `cert-manager`, controller/cainjector/webhook identities, isolated startup-check identity |
| CustomResourceDefinitions | 6 | Certificates, CertificateRequests, Issuers, ClusterIssuers, ACME Orders and Challenges |
| ClusterRoles and ClusterRoleBindings | 23 | Official controller/cainjector/webhook permissions and certificate viewer/editor roles |
| Roles and RoleBindings | 8 | Scoped leader election, webhook CA Secret management and startup-check dry run |
| Services, Deployments, admission configurations and Job | 9 | Three private Services, three single-replica components, two admission webhooks and API startup check |

Total: 51 objects, consisting of the 47 objects in the official static release
manifest plus a dedicated startup-check ServiceAccount, Role, RoleBinding and
Job. All 45 built-in objects are typed Terraform resources. The six official
CRD schemas use `kubernetes_manifest`, with Established waits and
`prevent_destroy` guards. The root's 53 Terraform files follow reflow's
one-block-per-file layout.

All five images are pinned to `v1.21.2` and immutable index digests verified
against the official Quay registry on 2026-10-18. This includes the controller's
ACME solver image argument, so challenge Pods also use the pinned artifact.
The [image record](upstream/image-digests.json) lists the exact values; each
Deployment, Job and solver argument contains its own literal pin.

The official runtime arguments, metrics Services, admission rules/selectors,
security contexts, probes, RBAC and Linux node selection are retained. Managed
built-in object labels identify Terraform. Metrics remain private ClusterIP
Services; no public Service or certificate traffic cutover is created here.

## Azure identity and consumers

The controller Pod retains `azure.workload.identity/use = true`, and both
`--cluster-issuer-ambient-credentials=true` and
`--issuer-ambient-credentials=true`. Its ServiceAccount remains
`cert-manager` in namespace `cert-manager`; the unchanged output names are
`namespace` and `service_account_name`. The website DNS identity roots depend
on this exact federation subject:
`system:serviceaccount:cert-manager:cert-manager`.

The Azure workload identity webhook supplies the projected token and tenant
environment. Each website Issuer chooses its own managed identity through
`managedIdentity.clientID`; the controller ServiceAccount deliberately has no
single identity annotation. This preserves separate SFM and Azurewebsiets DNS
identity ownership. No Azure role or federation resource is created by this
Kubernetes root.

## Bootstrap and admission readiness

1. Create namespace, identities, the complete official RBAC and six CRDs. Wait
   for every CRD's Established condition.
2. Roll out the webhook and cainjector with their required permissions. The
   webhook generates and maintains `cert-manager-webhook-ca` itself; Terraform
   does not create, read into configuration or own that private Secret.
3. Create the mutating and validating admission configurations, referencing the
   webhook Service and retaining the official CA injection annotation. Cainjector
   fills and rotates each `caBundle`. Terraform ignores exactly those generated
   bundle fields and continues to manage the full admission policy. The pinned
   CRDs do not configure a conversion webhook.
   Both webhook namespace selectors explicitly mirror AKS's observed exclusions:
   `control-plane NotIn true` and `kubernetes.azure.com/managedby NotIn aks`.
   The existing disable-validation exclusion remains managed in source.
4. Roll out the controller, then run the official startup API-check image as a
   tracked Kubernetes Job. The Job performs a dry-run CertificateRequest create
   to verify schema, webhook reachability and CA trust. Its ServiceAccount has
   only the required namespaced create permission, and Terraform waits for
   completion. Checks wait up to two minutes, with backoff limit four and a
   five-minute Job deadline; the Terraform create timeout is ten minutes.
5. Only after this root finishes, plan the separate workload Issuer/Certificate
   roots. Kubernetes custom-resource schemas must exist at Terraform plan time;
   putting those objects in this CRD installation plan would fail discovery.

The completed startup Job is retained in state and has no TTL or automatic
deletion. Changes to the three Deployments, two admission configurations or six
CRDs trigger its replacement and another check. Its image/version are explicit;
upgrades must update this check alongside the components. An unchanged apply
does not rerun the completed Job. A failed API check is a failed apply, with the
created infrastructure retained for diagnosis; Terraform does not perform a
Helm-style rollback.

## Deployment acceptance

The reviewed deployment added 51 objects, with none changed or destroyed. All
3 components and the startup API-check Job passed. An isolated self-signed probe
confirmed Ready Issuer and Certificate, with an Approved/Ready request at
revision 1. The owned namespace was fully removed. No Secret values were read,
and no public DNS or CA service was used.

All 3 Deployments are 1/1, all 6 CRDs are Established and the Job is Complete.
Injected CA bundles are populated, valid and equal. All 9 service-account RBAC
checks passed, including denials. Workload-identity projection and tenant checks
passed; an empty controller client ID is expected because each Issuer selects
its identity. Cert-manager pods have zero restarts and all Personal pods are Ready or Completed.
No Issuer, Certificate, CertificateRequest or Ingress remains after probe cleanup.
The fresh 60-second cainjector log sample had no error, forbidden or fatal entries.
Earlier probe-namespace Secret-not-found messages were transient during issuance/cleanup.

Traefik Deployment/Service identities, Deployment generation and public address
are unchanged. Public HTTP/HTTPS still return default 404; the HTTPS listener check
skipped certificate validation.

Benthic remains Running with one Ready node, all 24 baseline controllers and
its 4 apps ready. The global context is unchanged. Workload Issuers, ACME,
DNS and persistent-resource moves were not included. The final plan returned
exit 0 with no changes. No apply was needed after the source mirrored AKS's
observed namespace selectors.

The complete pulled state JSON equals its direct Entra-authenticated Azure blob
download. It contains all exact planned addresses: 46 managed blocks and 51
instances at serial 3. Its lineage differs from RG, AKS and ingress; its lease
is released/unlocked and the ETag is stable. Private state, credentials and
evidence are ignored and restricted to the operator, SYSTEM and local Administrators.

## State, validation and maintenance

This sibling's [terraform.backend.tf](terraform.backend.tf) contains its complete
literal Azure backend and separate state key in `personalcorestatefile/statefiles`.
This root is initialized and deployed. There is no Personal Helm release or state
to migrate. Benthic and its current cert-manager, Issuers and workloads are
unaffected.

Recursive Cloud Terrastodon reflow and `terraform validate` passed with cached
Kubernetes provider `3.0.1`. These checks establish source/schema consistency;
the startup and self-signed checks are recorded above. Azure identity access,
real DNS01/HTTP01 challenges, renewal and workload TLS remain future acceptance.
The three long-running components retain the official unset resource budgets;
observe their resource use and set explicit budgets when production load is
measured. The short startup check requests `10m` CPU/`64Mi` memory with a `128Mi`
memory limit. All three components have one replica, matching the previous
source; higher availability requires a separate sizing decision.

Upgrades are now an explicit source review: compare the new official manifest
with all typed objects, review RBAC and admission changes, replace the six CRD
definitions together, refresh provenance and image digests, and update every
component/solver/check version. Review the plan and complete the admission check
before workload plans. CRD deletion requires removing an explicit destruction
guard because deletion also removes the corresponding custom objects.

## Primary sources

- [Official static installation](https://cert-manager.io/docs/installation/kubectl/)
  and [pinned v1.21.2 release](https://github.com/cert-manager/cert-manager/releases/tag/v1.21.2).
- [Pinned release manifest](https://github.com/cert-manager/cert-manager/releases/download/v1.21.2/cert-manager.yaml)
  and [local provenance](upstream/README.md).
- [Webhook CA bootstrap](https://cert-manager.io/docs/concepts/webhook/)
  and [CA injector ownership](https://cert-manager.io/docs/concepts/ca-injector/).
- [Azure workload identity and per-Issuer identity selection](https://cert-manager.io/docs/configuration/acme/dns01/azuredns/).
- [Versioned startup Job](https://github.com/cert-manager/cert-manager/blob/v1.21.2/deploy/charts/cert-manager/templates/startupapicheck-job.yaml)
  and [its scoped RBAC](https://github.com/cert-manager/cert-manager/blob/v1.21.2/deploy/charts/cert-manager/templates/startupapicheck-rbac.yaml).
