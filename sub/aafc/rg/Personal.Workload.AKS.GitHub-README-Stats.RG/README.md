# GitHub README Stats migration source

The `resource_group` sibling is the only owner of
`Personal.Workload.AKS.GitHub-README-Stats.RG`. Payload roots look up existing inputs;
none creates another resource group. Its name follows the accepted
`Personal.Workload.AKS.` source layout.

The subscription, region, resource names, tags, token secret name, approved
image digest and ACME contact are literals in this source. Generated Azure
identity/OIDC values come from lookups by fixed resource names. Retained inputs
are only private kubeconfig paths and the staging/production
ACME choice. The Kubernetes context is the literal `Personal-AKS`.

No `terraform.tfvars.example` files are needed. Supply the private kubeconfig path
to runtime/certificate through `TF_VAR_kube_config_path`. The certificate root's
`acme_server` remains a deliberate operational choice: its existing default is
staging, with separate staging and production Issuer and account-key names.
For plans against the deployed public route, set `TF_VAR_acme_server` to
`https://acme-v02.api.letsencrypt.org/directory`.

| Root | Owns | State key suffix |
| --- | --- | --- |
| `resource_group` | Destination RG only | `resource_group.tfstate` |
| `identity` | New Personal workload identity, replacement AKS federation, and a vault-scoped Secrets User grant | `identity.tfstate` |
| `key_vault` | Adoption of the existing vault after its approved RG move; existing secret versions remain in place | `key_vault.tfstate` |
| `runtime` | Replacement cluster namespace, ServiceAccount, Deployment and ClusterIP Service | `runtime.tfstate` |
| `certificate` | Namespace HTTP01 Issuer, HTTPS Ingress, and host-scoped HTTP redirect middleware/Ingress | `certificate.tfstate` |

All suffixes are under
`resource-groups/Personal.Workload.AKS.GitHub-README-Stats.RG/` in
`personalcorestatefile/statefiles`. Each root's `terraform.backend.tf` contains
complete literal backend settings. On 19 November 2026, the resource group,
identity and private runtime were deployed from three reviewed saved plans.
The public route and production Issuer were deployed after the Namecheap cutover.
The certificate became Ready, HTTP redirected to HTTPS, and the public Stats SVG
returned HTTP 200 with trusted TLS. Vault adoption remains a later step. The
identity has `prevent_destroy` and reads the token from the retained vault.
Curl in the Stats image traced the original card failure to GitHub HTTP 401
(`Bad credentials`). The targeted legacy Terraform apply updated the secret.
After the Personal-AKS restart, workload identity and `/healthz` passed, and
a fresh request through the ClusterIP Service returned HTTP 200 with the
expected SVG.

## Deployment dependencies for Phase 2

1. Personal state storage, AKS, Traefik and cert-manager are deployed. The
   private deployment followed `resource_group`, `identity`, then `runtime`.
   Shared Traefik and cert-manager, including CRDs and admission webhooks, must
   be ready before planning the certificate root: `kubernetes_manifest` discovers
   installed cert-manager and Traefik Middleware CRD schemas during planning.
2. `identity` looks up `Personal-AKS` in `Personal.Core.AKS.RG` for the new OIDC
   issuer. It looks up the retained `teamygithubreadmestats` vault in the literal
   current RG `TEAMY-GitHub-README-Stats-RG`. This reads metadata only. No secret
   data source, secret resource, external evaluator or 1Password command is used.
3. `runtime` looks up `personal-github-readme-stats` in the Personal workload RG
   for its generated client/tenant IDs; vault and secret names are literals.
   Allow Azure role propagation before runtime acceptance checks.
   Verify that `Personal-AKS` in the supplied kubeconfig resolves to the new
   cluster resource. The fixed context has no old-cluster fallback, but a
   context name alone does not prove which server it references.
4. Use `certificate` after runtime and the shared add-ons are ready. Staging ACME
   is the default, with a distinct `letsencrypt-staging` Issuer/account key.
   Select the production ACME URL deliberately for production cutover; it uses
   `letsencrypt-prod`, preserving the live production issuer and TLS secret
   names on the new cluster. An HTTP01 request for the real hostname cannot
   succeed against the replacement until public DNS/port 80 reaches it. Do not
   treat a pre-cutover pending Certificate as a successful restore.
5. Verify the pinned image can be pulled, `/healthz`, a real Stats response and
   workload identity access to the retained token. Then perform the separately
   authorized registrar A-record cutover for
   `github-readme-stats.teamdman.ca` and confirm production TLS issuance and
   renewal. The Namecheap DNS records are managed in `ca.teamdman.iac`.

The image is the live audited immutable GHCR digest, written directly in source. The process args,
port, resources, health probes, host and Key Vault configuration reproduce the
legacy workload. Traefik replaces ingress-nginx according to the migration
platform decision; the public application hostname stays the same.

The HTTPS route explicitly selects Traefik's `websecure` entrypoint and TLS. A
separate HTTP route on `web` uses a namespace-local RedirectScheme middleware.
Only this hostname redirects; hello's HTTP endpoint is unaffected. Default
Traefik rule-length priority lets the more-specific HTTP01 challenge path win
over the application's `/` redirect route. Verify the challenge exception and
HTTP-to-HTTPS redirect during replacement acceptance; no global redirect is used.

## State and persistent-resource handoff

The legacy combined backend is `teamy-github-readme-stats.tfstate` in the shared
legacy account. Keep it frozen only during its eventual ownership handoff, and
retain a versioned backup and exact object-ID/address inventory first. Do not
copy the combined state into these independent sibling states. New cluster
Kubernetes objects and the new identity are fresh objects, so their state starts
empty; no old Kubernetes state is transplanted to the replacement API server.

These legacy addresses remain owned by the legacy stack during coexistence:

- `azurerm_key_vault.main`: retained `teamygithubreadmestats`, RBAC enabled,
  purge protection and 90-day soft-delete retention.
- `azurerm_key_vault_secret.github_token`: retained existing `github-token`.
  The legacy Terraform root reads the value from 1Password and manages its Key
  Vault versions. The Personal runtime reads it through workload identity.
- `azurerm_user_assigned_identity.main`,
  `azurerm_federated_identity_credential.main` and the old vault role assignments:
  keep old-cluster trust and access while Benthic serves traffic.

The new `azurerm_user_assigned_identity.this` is a separate identity in the
Personal RG; its `azurerm_federated_identity_credential.aks` trusts only the
replacement issuer and its Secrets User grant permits use of the existing
vault. The old identity is not moved into the new RG.

For rotation while the vault is in its legacy RG, plan from the original
`teamy-github-readme-stats/platform/iac` root with its existing backend and the
updated 1Password item. Scope the plan to
`-target=azurerm_key_vault_secret.github_token` while Benthic is unavailable.
Apply the reviewed plan only if its sole managed change is an in-place update
of the existing secret. A role change may mean the Azure caller differs from
the one recorded by the legacy stack. Saved plans and legacy state contain the
token value, so keep them in protected storage. After apply creates a new
version, restart Stats and verify a fresh card over its private service.

The `key_vault` sibling supplies the concrete post-move adoption source, with
mandatory import of the literal post-move vault ID and `prevent_destroy`. Verify
that exact resource exists before using the root. Its name,
RBAC, public-network setting, purge protection and 90-day retention match the
legacy declaration. It must not run before the separately authorized move and
state handoff. The original token and versions remain inside the same vault;
this root has no secret resource or secret-value lookup.

Before moving, review Azure support/dependencies, preserve exact vault and
secret-version IDs privately, freeze the legacy writer and take state backups.
Move the existing vault into the Personal RG and transfer the vault owner from
`azurerm_key_vault.main` to `key_vault/azurerm_key_vault.this` with ID
reconciliation. Plan the destination Terraform owner for the existing
`github-token` and its versioned resource ID before releasing the legacy secret
address. Preserve the secret and its versions during the handoff. Record the
single Terraform owner and its credential input in the cutover record. The
current vault adoption root has no secret resource, so the destination secret
configuration and state handoff need their own review before the move.

Edit the literal vault lookup RG in `identity` only after the
actual move, reconcile old and new identities' grant scopes whose resource ID
changed, and prove both clusters' access during coexistence. The metadata lookup
alone does not adopt either object. Do not delete the legacy RG or state owner
until the vault move and deliberate state releases are verified. Never run the
old token evaluator simply to populate a new state.

The `key_vault` sibling explicitly owns a replacement vault-scoped Secrets User
grant for the old runtime identity, looked up as `teamy-github-readme-stats` in
the retained legacy RG. The new identity's grant remains owned by `identity/`.
Map existing matching assignments to one owner before applying;
preserve all other administrator/publisher RBAC grants through their existing
owners as part of the frozen move inventory. The two runtime identity grants make the
old/new runtime access repair concrete without moving the legacy identity.

## Source validation

Only `cloud_terrastodon.exe terraform reflow --recursive` and
`terraform validate` are authorized for this phase. Provider packages and lock
entries are reused from the trusted local caches; no backend metadata or old
state is copied. Validation checks static schemas and references; it does not
prove cluster, CRD, registry, Azure grant, secret, DNS or certificate readiness.
