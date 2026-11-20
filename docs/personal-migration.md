# Personal and reference architecture migration

**Plan status:** Personal-AKS is restored. Private Stats passed acceptance after the Terraform-managed token rotation. Public cutover remains a separate step.  
**Primary implementation root:** `teamy-azure-iac` repository root.  
**Last updated:** 2026-11-19.  
**Intent audit:** Rechecked through U51. U45 refreshes the evidence and proposes a recovery sequence. U46 records the billing pause. U47 authorizes recovery and the private Stats deployment. U48 and U49 authorize the curl image and in-pod diagnosis. U50 confirms Terraform ownership for secret rotation. U51 confirms the secret update and leads to restart and private acceptance. Prior evidence covers input-example cleanup, cert-manager deployment, the AKS workload layout and NGINX hello authorization. Retained 2026-10-16 evidence covers the original migration request, the
state/agent walkthrough, explicit azurewebsiets.net move, live AKS coverage and
next-step/final-group-layout, NGINX Core ownership, sibling deployment-root and
Cloud Terrastodon reflow, complete-code-before-deployment, explicit Phase 1
implementation authorization, maintained-controller transition, test-vault
removal, literal subscription/tag, minimal-indirection and main/object-output
follow-ups, the explicit Personal bootstrap deployment authorization, and supplied AGENTS.md instructions.

## How to update this plan

- `[ ]` Not started; `[~]` in progress; `[x]` complete; `[!]` blocked.
- Put status in each work-item heading and update its completion notes together.
- Record evidence beside the task it proves. A phase is complete only when all
  of its work items are complete.
- Keep the offline scaffold separate from future deployment and migration work.
  Completion of this phase does not authorize that later work.

The user confirmed two phases: finish all new migration Terraform first, then
deploy it. The source now includes 29 Personal roots and six reference foundation/
transition roots, with ownership maps and preservation procedures. Generated
deployment values use direct lookups where possible; actual operational inputs
remain documented. Actual workload restore/image acceptance, resource moves,
agent-connectivity and certificate acceptance remain Phase 2 work because they
require deployed candidates. Passing a source gate grants no deployment authority.

## Authoritative user guidance ledger

| ID | Active guidance | Coverage |
| --- | --- | --- |
| U01 | Consolidate Personal infrastructure in `teamy-azure-iac`; use `Cloud-Terrastodon` and `Reference-Architecture` as references. | 1.1, source references, ownership matrix. |
| U02 | Scaffold now; run no Terraform commands except `validate`. | 1.2–1.4, validation boundary. No cloud writes. |
| U03 | Keep two functioning ownership islands: Reference Architecture deploys through Azure DevOps after bootstrap; Personal deploys manually for now. | 1.2–1.3, independent roots/backends; no Personal pipelines. |
| U04 | Use dots between partition, Core/Workload, purpose and RG; keep hyphens within purpose/environment identifiers. Use Core rather than Hub. | Naming contract and destination matrix. |
| U05 | Reference names: `Reference-Architecture.Core.StateFile.RG`, `.Core.Networking.RG`, `.Core.AZDO-AgentPool-1-DEV-VMSS.RG`, `.Workload.MyFirstWorkload-DEV.RG`. Environment stays in the hyphenated purpose for now. | 1.3; future cutover 2.2. |
| U06 | Personal names: `Personal.Core.StateFile.RG`, `.Core.Networking.RG`, `.Core.AKS.RG`, `.Workload.SFM-Website.RG`, `.Workload.azurewebsiets.RG`. | 1.2; Core names remain current. U42 supersedes the workload prefix with `.Workload.AKS.`. |
| U07 | AKS remains outside the reference architecture; replace the Benthic naming in the future Personal deployment. | AKS destination shell; G3 and 2.3. |
| U08 | Reference architecture must own its networking and IP address management; Personal uses a different CIDR so future peering remains possible. | 1.2–1.3; address plan. No peering now. |
| U09 | Repair shared networking and current IaC state ownership without disrupting the VMSS agents or state access. | Existing roots unchanged; G1/G2, 2.1–2.2. |
| U10 | Bootstrap state groups hold storage for statefiles; legacy bootstrap creates the group, random suffix, operator IP rule, account and container. | 1.2–1.3 bootstrap roots; state transition 2.1. |
| U11 | Future state migration may create new accounts, copy state blobs and then update consumers. Preserve existing backend dependencies until verified. | State protocol; do not equate blob copying with resource migration. |
| U12 | Preserve and migrate NGINX hello after tracing its storage content and Kubernetes resources. | NGINX findings, workload ownership per U42 (superseding U22), 1.6, 2.0j and 2.3. |
| U13 | Migrate Benthic, three workload groups, AKS managed node group as part of AKS, and GitHub README Stats. The initial CloudTerrastodon-test migrate classification is superseded by U28. | Full inventory; test removal is separate, with no replacement source. |
| U14 | Earlier AI migrate classification is superseded: AI appears unused and is a retirement candidate; do not redeploy it. | AI excluded from scaffold; later inventory/retirement gate G5. |
| U15 | Ignore Raddest DNS, legacy Terraform, NetworkWatcher, existing reference agent pool and MyFirstWorkload groups in this migration. | Inventory: preserve existing groups; stage future reference names only. |
| U16 | Resource groups cannot simply be renamed; move eligible contained resources into a destination group where appropriate, preserving DNS such as raddest.ca. | Move/rebuild gates; Raddest explicitly untouched. |
| U17 | If disk space fails, wait for the user to resolve it; installed tools may require sandbox elevation. | Execution constraints; no self-directed disk cleanup. |
| U18 | Move the existing `azurewebsiets.net` DNS zone, using the same resource-move approach as the separately planned Raddest move. | Explicit zone move into `Personal.Workload.AKS.azurewebsiets.RG` after U42, G6 and 2.4; preserve delegation and current traffic during the group move. Raddest execution scope stays unchanged. |
| U19 | Walk through state migration and how the reference agents keep working; still no Terraform commands beyond `validate`. | State operation distinctions, agent bridge/canary sequence, backend auth audit, and detailed future acceptance. Only the changed reference state scaffold was validated in this follow-up. |
| U20 | Determine whether live AKS contains anything outside the old IaC and whether redeploying it will restore the workloads. | Fresh read-only audit 1.5 and `aks-live-audit.md`; distinguish matching application inventory from unproven full configuration/data restoration. G7 and 2.5 must pass before retirement. |
| U21 | Recommend the next concrete migration step and provide a text summary of the final resource-group layout. | Next source implementation slice 1.6; naming/disposition tables and repository README define the target groups, retained groups and unresolved destinations. This request does not authorize deployment or lift the validate-only limit. |
| U22 | Put the NGINX hello storage in `Personal.Core.AKS.RG` because it belongs to the core cluster/ingress setup; do not create a separate NGINX RG. | Historical instruction implemented in 1.6; superseded by U42's dedicated AKS workload group. Content preservation and separate Kubernetes objects remain required. |
| U23 | Decouple resource-group creation from components under `sub/<subscription>/rg/<group>/`: `resource_group/` owns the RG; sibling roots such as `storage_account/` expect it to exist. Apply the same pattern to other workloads. | Split Personal StateFile into `resource_group/` and `storage_account/`, and Networking into `resource_group/` and `vnet/`. Use data lookups and independent states/keys; extend the pattern in 1.6. Existing subscription directory stays `aafc`. |
| U24 | Use `cloud_terrastodon.exe terraform reflow --recursive` to split/rename Terraform files into the established convention; authoring `main.tf` first is acceptable. | Run default recursive reflow on all changed Personal trees, then validate affected roots; README records the workflow. Reflow is source editing, not permission for other Terraform executable commands. |
| U25 | Phase 1 writes all new migration Terraform; Phase 2 deploys it only after the code is complete. We are still in Phase 1. The first actual deployment is the Personal state resource group, followed by its storage account for the other roots' state. | Source-completion gate G8, tasks 1.6–1.9 and first Phase 2 task 2.0. No early canary/foundation deployment while source is missing; two local bootstrap states precede remote backends. |
| U26 | Finish Phase 1 AKS, add-on and workload Terraform using sibling roots; run recursive reflow and validate, without deploying. | 1.6–1.9, 27-root source map and final validation evidence. No init, plan, apply, state/import execution or cloud mutation. |
| U27 | Explain the maintained-controller recommendation, implement that transition in Phase 1 and summarize it. | Traefik on the candidate, class traefik, cert-manager continuity, per-host HTTPS/redirects and HTTP01 handling; ingress-transition.md and workload source. The initial Helm implementation is superseded by U37. Benthic remains untouched. |
| U28 | Leave the CloudTerrastodon test vault now; do not plan a replacement; plan its removal. | Supersedes U13 only for that group. Read-only inventory found vault arbitraryname only; G4 is a later removal/custody gate. No new destination/root and no deletion in Phase 1. |
| U29 | Subscription ID and tags must be string literals; remove their variables. | 1.10 replaces subscription inputs and inherited/local/variable tag maps in the new Personal and reference scaffolds, removes obsolete declarations/example inputs and reflows/validates all affected roots. Existing deployed roots remain untouched. |
| U30 | Minimize indirection throughout Teamy Azure IaC, including storage account values and RG locations, not only StateFile. Favor literals for single-value author-time choices because variables add lifetime maintenance debt. Apply the same principle to the smaller reference changes. | 1.11, AGENTS.md and the source map: fixed values are literal across all new roots; generated metadata uses direct named lookups; every remaining variable has an actual operational reason. No deployed roots are changed. |
| U31 | StateFile RG should have one output of the complete RG object, instead of separate ID/name outputs; prefer main rather than this for RGs and storage accounts. | 1.12 applies the convention consistently to the new Personal RG/account resources and lookups. Each owner has one complete object output; account outputs are sensitive. Update import references/maps, reflow and validate without state/deployment actions. |
| U32 | Check readiness and, if ready, apply the StateFile resource group followed by the storage account. | Authorizes only 2.0 and its necessary init, saved-plan review/apply and verification. Preserve two independent local states. Do not migrate backends/state or deploy other roots. |
| U33 | Keep the deployed bootstrap roots recoverable from source without adding a remote backend: write imports for the existing objects so an operator without the authoritative state can adopt them; a genuinely fresh deployment comments out those import blocks. | 2.0a adds four literal ARM-ID imports beside the owning resources, retains local backends, pins the deployed grant principal across callers and documents recovery versus fresh creation. Reflow/validate only; no import, plan, apply or state/backend operation in this edit. |
| U34 | Deploy Personal.Core.Networking.RG, followed by its VNet and subnets, using the new state storage account. | 2.0b authorizes the two networking roots only: live address/backend preflight, literal separate fresh Entra-authenticated Azure state keys, init/validate, reviewed saved plans/apply and verification. No AKS, peering, legacy state movement or reference network/agent changes. |
| U35 | Also create Personal.Core.Networking.RG/storage_account_network_access, responsible for adding the VNet allow rules to the state file storage account. | 2.0c adds a separately stated AzAPI ACL updater, preserving all existing non-VNet ACL fields and other VNet rules. AKSSubnet is the current target because it alone has Microsoft.Storage. Bootstrap ignores only subnet IDs to avoid undoing the addition; operator IP/default policy stay with bootstrap. Serialize ACL updates, guard against stale plans and verify preservation. No RBAC/AKS/reference changes. |
| U36 | Deploy Personal.Core.AKS.RG followed by the new AKS cluster using the new state storage account; leave Benthic and its workloads running. | 2.0d permits two fresh remote states, preflight, init/validate, reviewed saved-plan apply and readiness/state verification. No old-state copy, ingress/workload install, DNS cutover or Benthic retirement. |
| U37 | Explain the Traefik Helm implementation and rewrite it to deploy the actual Kubernetes resources directly. | 2.0e replaces the unapplied ingress Helm source with typed Kubernetes objects and pinned vendored CRDs; reflow/validate and source review. The original cert-manager chart exception is superseded by U39. No ingress installation is implied by this source request. |
| U38 | Deploy the Traefik ingress controller on the new Personal-AKS using the new state storage account; leave Benthic and its workloads running. | 2.0f authorizes ingress only: distinct fresh remote state, init/validate, reviewed saved-plan apply, live controller/public-listener and state verification, and Benthic preservation checks. No cert-manager, workload installation or DNS cutover. |
| U39 | Cert-manager also uses Helm; convert all Helm usage to flat Kubernetes Terraform. | 2.0g replaces the only remaining active Personal Helm root with direct resources and removes provider/release/lock dependencies. Preserve fixed names, identity/issuer contracts, pinned upstream provenance and lifecycle/readiness behavior. Reflow/validate only; no cert-manager deployment or legacy-release changes. |
| U40 | Accept upstream as reference; clean up the backend scaffolding after the explanation that fixed settings should be inline. | 2.0h inlines the remaining Personal Azure backends and removes redundant examples. Preserve exact keys, six deployed Azure pointers, two bootstrap local states and upstream files; reflow/validate and update docs without backend initialization or state migration. |
| U41 | Deploy cert-manager to Personal-AKS using the new state storage account; leave Benthic and its workloads running. | 2.0i permits isolated init/validate, reviewed saved-plan apply, controller/admission/token/state verification and a disposable self-signed readiness probe. Preserve Benthic, Traefik, existing state and default context; no application Issuers, public issuance or DNS changes. |
| U42 | Move `Personal.Core.AKS.RG/nginx_hello` and `nginx_hello_storage` into `Personal.Workload.AKS.NGINX-Hello.RG/kubernetes` and `storage_account`; prefix the other Personal workload groups with `Personal.Workload.AKS.`. | 2.0j adds one dedicated RG owner and updates the undeployed workload folders, literal RGs, backend keys, destination import IDs and documentation. Supersedes U22 and the old workload names in U06. Source-only reflow/validate; preserve deployed resources/state, legacy overlap lookups and application names. |
| U43 | Once the source changes are done, deploy the NGINX hello workload. | Complete 2.0j first, then 2.0k deploys only the new workload RG and Kubernetes roots using fresh Azure states. Reuse retained storage read-only during overlap, preserve Benthic/shared platform/DNS, review exact saved plans and verify content/readiness/state. Storage-account move/adoption is separately gated and unnecessary for this candidate deployment. |
| U44 | Count the remaining `terraform.tfvars.example` files; they should not be needed under the literal-value philosophy. GitHub README Stats is the next workload being considered for deployment. | 2.0l removes eleven redundant templates, documents real operational inputs and reviews Stats dependencies. Preserve all twelve operational variables and the existing staging/production choice; no production default, deployment or cutover is inferred. |
| U45 | Reassess the migration after the pause and plan how to resume. | 2.0m records current Azure, Kubernetes, state and source evidence. 2.0n and 2.0o describe proposed recovery and private Stats deployment. Deployment and traffic changes require separate authorization. |
| U46 | The subscription was paused earlier because it hit a billing limit. | 2.0m records the user-confirmed cause of the subscription pause and the current enabled subscription. 2.0n adds credit and cost checks before restart. |
| U47 | There is enough credit. Restore Personal-AKS and proceed with the proposed deployment. | 2.0n authorizes managed Personal-AKS recovery and 2.0o authorizes the private Stats resource group, identity and runtime in order. Benthic recovery and public cutover remain separate. |
| U48 | Add curl to the Stats container. | Build curl into the app runtime image for diagnostic use. |
| U49 | Publish the Stats image, deploy its new digest to Personal-AKS, then use curl to see GitHub's error. | Roll out the authenticated registry digest through the existing runtime Terraform state and run one read-only GraphQL diagnostic inside the resulting Stats pod. |
| U50 | The 1Password token is updated. Azure resources, including the Key Vault secret, are managed by Terraform. Recheck the rotation workflow. | Use the legacy Stats secret owner for the current rotation. Correct the docs that prescribed rotation outside Terraform and preserve a single Terraform secret owner at the future vault handoff. |
| U51 | The targeted Terraform apply succeeded and Key Vault has the new secret version. | Restart Stats on Personal-AKS to load the value at startup and verify private card generation in 2.0o. |

## Intent audit evidence

- **Pass 1 — extraction:** Reread the complete current request from the three
  checkout references through the final nine target names, including the spoken
  corrections, the state/agent/DNS follow-up, live AKS coverage question and
  next-step/final-group-summary request, NGINX Core-group correction, sibling-root
  separation, recursive-reflow and complete-code-before-deployment instructions.
  U01–U51 preserve all group
  dispositions, the AI correction, NGINX
  investigation, ownership split, state-copy sequence and validate-only limit.
  The explicit implementation request and both current user answers are captured
  as U26–U28, including controller replacement and test removal without redeploy.
  U29 preserves the later correction that subscription and tag values belong
  directly in source, not caller-supplied Terraform variables.
  U30 extends that direction across storage, location and other fixed choices,
  with Personal as the main correction and the reference scaffold included.
  U31 retains both the main-label preference and the complete-object output
  requirement, including the StateFile RG example and account consistency.
  U32 authorizes only the first Personal state bootstrap and the commands needed
  to review, apply and verify it; all other Phase 2 execution remains future.
  U33 supersedes the proposed next-step backend relocation with source imports
  and explicitly distinguishes empty-state adoption from a fresh Azure deployment.
  U34 preserves explicit RG-before-VNet/subnets deployment order and use of the
  new Personal account with two distinct fresh state keys.
  U35 adds the named access sibling and its isolated state, preserving the
  existing firewall while contributing an endpoint-enabled subnet rule.
  U36 retains RG-before-cluster order, the new state account and continued
  Benthic operation. U37 changes ingress authoring while that authorized
  deployment continues; it does not request ingress installation.
  U38 now explicitly authorizes that ingress deployment on Personal-AKS only,
  preserving the new state-account requirement and Benthic uptime.
  U39 broadens the direct-resource convention to all active Personal Kubernetes
  source, including cert-manager; it requests conversion, not installation.
  U40 accepts the upstream reference directory and requests backend cleanup in
  the same literal-configuration style, with source cleanup rather than deployment.
  U41 now authorizes cert-manager installation on Personal-AKS with the new
  state account while retaining Benthic and its applications.
  U42 subsequently replaces NGINX's source ownership with its own AKS workload
  group and prefixes the other three workload groups. Both old source-folder
  references and the requested `storage_account`/`kubernetes` sibling names are
  recorded in 2.0j. This reversible source refactor grants no deployment authority.
  U43 subsequently authorizes the NGINX candidate only after that source work
  completes. The existing overlap contract allows a new reader without moving
  or adopting the retained account; its physical move remains a separate gate.
- **Pass 2 — traceability:** Matched every ledger row to the 27 Personal roots,
  six reference foundation/transition roots, the bounded 2.0 execution authorization, disposition/address/state tables or explicit G1–G8 and
  phase-2 tasks. The initial separate NGINX name was an agent proposal and is
  superseded by U22. Stats naming, the initial storage-name inputs (now superseded
  by U30 literals), CIDR/subnet
  reservations and new reference NAT remain scaffold choices, not claims that
  the user selected those details or that they are deployed.
- **Pass 3 — adversarial omission:** Rechecked ignored DNS/backend/agent/workload
  groups, managed MC lifecycle, exact `azurewebsiets` spelling, hyphenated DEV
  purpose, Core versus Hub, manual Personal versus later pipeline-driven reference
  deployment, future peering, test-source uncertainty and current AI retirement
  intent. Rechecked DNS-zone move versus ingress cutover, old/new agent access,
  writer freezes versus application uptime, and backend authentication versus
  deployment identity. Rechecked that a matching live application list is not
  presented as a complete manifest, data backup or successful restore. Confirmed
  the U21 next-step recommendation addressed the then RG-only AKS/workload scaffolds, did not
  depend on rebuilding reference agents first, and retains unresolved/ignored
  group dispositions in the final layout. Rechecked that hello storage ends up
  in the then-current Core AKS RG under U22 (subsequently superseded by U42), with one group owner and preserved data, while the
  AKS-managed node group and controller/hello object distinction remain intact.
  Rechecked that component roots look up their group instead of creating it,
  two independent local states break the state-account bootstrap cycle, existing
  Azure/state ownership is unchanged, and the requested source reflow actually ran
  before post-reflow validation.
  Rechecked the strict Phase 1/2 boundary, Personal RG-before-account bootstrap,
  and that live restore/canary tests do not become impossible predeployment gates.
  Rechecked U26's explicit implementation/reflow/validate boundary, U27's
  maintained Traefik transition and preserved nginx application containers, and
  U28's removal rather than replacement of the test vault. Concrete imports,
  old/new DNS/vault grants, fresh Kubernetes states, retained site bytes/token,
  HTTPS/HTTP01 routes and reference candidate permissions have source coverage.
  Rechecked that U29 removes only subscription/tag inputs, preserves their
  existing values, and retains the other deployment-time contracts and all
  ownership/backend boundaries. Provider, issuer, import-ID guard and backend
  example subscription values are consistent after the correction.
  For U30, checked every remaining Personal declaration: nine machine kubeconfig
  paths, two changing DNS cutover targets and one real staging/production ACME
  choice. No RG or storage root has inputs. Fixed names, regions, pins and sizes
  are literals; generated OIDC/client/principal IDs are named lookups. Storage
  account names were source choices with read-only availability checks in Phase 1.
  Phase 2.0 subsequently deployed only the Personal state account and its writer
  grant, as recorded below.
  U31 traceability covers six RG owners and four account owners, their data
  lookups/imports, output sensitivity and consumer scans. The adversarial check
  confirms no old scalar-output consumer was missed, protected imports still
  target the same Azure IDs and no deployed legacy resource address was changed.
  U32 readiness and execution checks preserve two independent local states,
  restrict saved-plan actions to the four new Personal bootstrap resources,
  disable unrelated provider registrations and leave legacy states, workloads,
  agents and all later migration operations untouched.
  U33 traceability covers every deployed managed bootstrap resource, fixed ARM
  import IDs, preserved local backends and explicit fresh-deployment comments.
  Rechecked that recovery under another caller preserves the original grant,
  imports do not auto-create absent objects or restore state history, the caller
  IP allowlist can reconcile, and only one authoritative state owns each root.
  U34 traceability covers both remote backend blocks, five managed resources,
  live CIDR checks, exact saved-plan allowlists and complete state-backup proof.
  Rechecked that no legacy state is copied, no bootstrap local state changes,
  and no peering, AKS or reference-agent work expands the authorized scope.
  U35 traceability and adversarial review cover selective ACL-field ownership,
  preservation of other rules/IP/defaults, new-root state isolation and serial
  updates with a live snapshot guard rather than a second whole-ACL owner.
  U36 maps to separate fresh RG/cluster backend keys and exact create-only
  plans, with old-cluster health baselines and private credential/state custody.
  U37 maps to all eighteen direct Kubernetes instances, ten versioned CRDs,
  source validation and independent RBAC/health/dependency review. Helm removal
  applies to ingress only; CRD lifecycle and future routing acceptance stay explicit.
  U38 maps to 2.0f and its separate fresh backend, exact-create plan review,
  isolated Kubernetes target, controller/RBAC/listener checks, protected state
  backups and before/after Benthic health. Adversarial review keeps certificate
  issuance, workload traffic, DNS and legacy state ownership outside this slice.
  U39 maps to 2.0g, the only remaining active Helm release/provider/lock entry,
  downstream identity/output contracts and a repository-wide final scan. The
  Reference-Architecture source scan found no active Helm use. Historical
  Benthic ownership addresses remain evidence; no uninstall or state adoption
  is inferred from replacing this undeployed candidate source.
  U40 maps to exact example-key preservation in twenty inline backend blocks,
  removal of twenty-seven redundant templates, unique keys and invariant checks
  for the eight deployed backend declarations/caches and both local state files.
  Adversarial review excludes bootstrap relocation, backend initialization,
  reference/legacy changes and alteration of accepted upstream provenance.
  U41 maps to 2.0i, exact-create saved-plan review, verified isolated target,
  controller/admission trust and identity projection checks, protected state
  custody, a temporary local self-signed probe and complete cleanup. Adversarial
  review excludes public CA/DNS traffic, application adoption and legacy writes.
  U42 maps to 2.0j and the seven-group disposition/current source map. Its separate
  extraction, traceability and adversarial passes cover both NGINX folder moves,
  all other workload prefixes, the new RG owner, unused state-key renames and
  post-move ARM IDs. They explicitly preserve legacy runtime/solver locations,
  data, namespaces, resource names, nine deployed roots and prior state custody;
  no initialization, state migration or Azure move is inferred from a folder move.
  U43's extraction preserves the explicit source-before-deployment ordering;
  traceability maps to 2.0j completion followed by 2.0k. Adversarial review keeps
  the deployment bounded to a fresh RG and five Kubernetes objects, preserved
  legacy storage/content, separate state keys and healthy Benthic/platform.
  U44's extraction separates the example count/cleanup request from consideration
  of Stats as the next deployment. Traceability maps all eleven templates and the
  twelve remaining inputs to 2.0l. Adversarial review preserves credential paths,
  DNS cutover targets and Stats' deliberate staging-to-production ACME workflow;
  it does not convert a source cleanup into production issuance or deployment.
  For U45, the extraction pass identified the request for current evidence and
  a resume plan. The traceability pass linked the findings to the recovery and
  private Stats tasks. The final pass checked the difference between October's
  successful deployments and current service health, and kept recovery, public
  traffic, retained-resource ownership and the reference-agent handoff distinct.
  U46 identifies the billing limit as the cause of the subscription pause.
  2.0m distinguishes that confirmed history from the current cluster status.
  2.0n uses it to sequence recovery without assuming credit availability or
  successful cluster startup.
  U47 provides the credit decision and authorizes the first two steps of the
  recovery plan. 2.0n and 2.0o carry that scope into execution. The prior plan
  assigns Benthic recovery to a separate decision and Stats DNS/TLS to a later
  cutover.
  U48 selects curl in the app image. U49 authorizes publication, rollout and
  diagnosis from that pod. The 2.0o record follows the verified registry digest
  into Terraform and distinguishes a GitHub credential rejection from an Azure
  workload identity or vault failure. Token replacement is a subsequent step.
  U50 confirms that Terraform should publish the replacement already stored in
  1Password. The ownership review traced this to the legacy secret address and
  clarified the future state handoff. Benthic's status limits the current
  rotation plan to the secret and its dependencies.
  U51 reports that the user completed that apply. The follow-up verified the
  restarted Personal pod and fresh card without expanding into public cutover.
  No old
  teardown or AI-preservation instruction was carried
  forward; Raddest's separate move is not silently executed here.
- **Known source limitation:** The full user request sequence is available in
  the current context; original implementation tool outputs before compaction
  are represented by this ledger and protected evidence. The U36–U51 incremental
  audit separately checked extraction, task traceability and preserved scope.
  The original scaffold evidence was source-level. Phase 2 inspects only the
  authorized new Personal states. A fresh read-only live Kubernetes/Azure inventory is now
  recorded in 1.5; full configuration parity and restoration remain unproven.

Older rebuild notes are historical evidence only; their naming, teardown and
AI-preservation instructions do not override this request.

## Verified foundation and source references

The original foundation findings below came from source configuration. A fresh
read-only Azure/Kubernetes inventory was subsequently captured on 2026-10-15:
see [Benthic live audit](aks-live-audit.md) and 1.5. Keep declared versions and
historical notes separate from those observations and remaining restore gates.

| Reference | Role and evidence |
| --- | --- |
| `teamy-azure-iac/sub/aafc/rg/` | Destination repository; existing state and network roots use separate Terraform state keys. |
| `ca.teamdman.iac/init/main.tf` | Creates `CACN-Terraform-PROD-RG`, random-suffixed storage account, operator public-IP restriction and state container. |
| `ca.teamdman.iac/src/cluster.tf`, `src/modules/cluster/` | Benthic AKS and Entra admin group; source still pins Kubernetes 1.29.10 and kubenet. These are legacy declarations, not a new cluster specification. |
| `ca.teamdman.iac/src/ingress_nginx.tf`, `src/cert_manager.tf`, `src/nginx_hello.tf` | Shared ingress controller, certificate manager and hello workload are in one Terraform root. |
| `net.azurewebsiets.iac/module_impls.tf`, `modules/azurewebsiets/` | Azurewebsiets storage, DNS, Kubernetes and workload identity; current source is outside `old/`. |
| `sfm-website/iac/` | SFM storage, `superfactorymanager.ca`, ingress, certificate identity and registrar integration. |
| `teamy-github-readme-stats/platform/iac/` | Stats Kubernetes resources, workload identity and Key Vault. |
| `Reference-Architecture/AzureDevOps/Projects/MyCoreProject/Repos/Infrastructure/` | Reference project, bootstrap identity, permissions, pipeline template, agent pool and state consumers. |
| `Reference-Architecture/AzureDevOps/Projects/MyFirstWorkload/Repos/Infrastructure/` | Workload project and its independent Terraform/pipeline lifecycle. |
| `Cloud-Terrastodon` | Tooling reference. No production declaration of the test RG was found during the scoped source search; do not modify the Rust application for this migration. |
| `rebuild/REBUILD-PLAN.md` | Historical August inventory identifies Stats' full RG name and possible test Key Vault; refresh before using as deployment evidence. |

The first three named repositories were provided as local checkout paths by the
user. They are recorded here by repository name rather than drive letter. SFM,
Stats and the legacy IaC sources were located from source references. Checkout
locations vary by machine; no literal machine path is needed or persisted.

## Resource group disposition

| Existing group | User disposition | Destination or next decision |
| --- | --- | --- |
| `CACN-CloudTerrastodon-Test-RG` | Later removal, no replacement | U28 supersedes migrate. Read-only Azure inventory on 2026-10-15 found only Key Vault arbitraryname in Canada Central. Preserve now; G4 requires custody/dependency and deletion-scope review before removal. |
| `CACN-Cluster-Benthic-PROD-RG` | Migrate | `Personal.Core.AKS.RG`; cluster and shared add-ons, with workload cutover later. |
| `CACN-ClusterWorkload-Benthic-azurewebsiets-PROD-RG` | Migrate | `Personal.Workload.AKS.azurewebsiets.RG`; explicitly move the existing `azurewebsiets.net` zone with records, then reconcile IDs, access and certificate solvers before later traffic cutover. |
| `CACN-ClusterWorkload-Benthic-nginx-PROD-RG` | Migrate | `Personal.Workload.AKS.NGINX-Hello.RG` for hello storage and replacement runtime, per U42. Preserve content and reconcile storage ownership/IDs during the later move or transfer. |
| `CACN-ClusterWorkload-Benthic-sfm-website-PROD-RG` | Migrate | `Personal.Workload.AKS.SFM-Website.RG`. |
| `CACN-Raddest-DNS-RG` | Ignore in this phase | Preserve group, zone and records here. The separately planned Raddest move is the user's analogy for the azurewebsiets move, not an instruction to execute it now. |
| `CACN-Terraform-PROD-RG` | Ignore | Preserve shared legacy backend while consumers are migrated. |
| `MC_CACN-Cluster-Benthic-PROD-RG_Benthic-PROD-AKS_canadacentral` | Migrate with AKS | Managed by AKS; do not adopt, rename, move or delete independently. |
| `NetworkWatcherRG` | Ignore | Preserve. |
| `TEAMY-AI-PROD-RG` | Retirement candidate | G5: verify unused; no new definition or deletion in this phase. Supersedes initial migrate label. |
| `TEAMY-GitHub-README-Stats-RG` | Migrate | `Personal.Workload.AKS.GitHub-README-Stats.RG`, retaining the workload identifier with U42's AKS prefix. User's `...-R` entry was truncated; full legacy name confirmed in source. |
| `Teamy-Hub-AZDO-AgentPool-1-DEV-VMSS-RG` | Ignore existing deployment | Preserve active roots; stage `Reference-Architecture.Core.AZDO-AgentPool-1-DEV-VMSS.RG` for a later reference transition. |
| `Teamy-Infrastructure-as-Code-RG` | Repair | Preserve `teamyiac` and its two state keys. Introduce independent Personal and reference state boundaries first. |
| `TEAMY-NETWORK-RG` | Repair | Preserve current VMSS connectivity. Reference-owned networking staged separately; Personal uses another address space. |
| `Teamy-Workload-MyFirstWorkload-DEV-RG` | Ignore existing deployment | Preserve active roots; stage `Reference-Architecture.Workload.MyFirstWorkload-DEV.RG` for later. |

## Address plan and ownership

Personal deployment boundaries follow U23/U42: each of the seven destination groups
has one `resource_group/` root. State storage is the sibling `storage_account/`
root, and VNet/subnets are the sibling `vnet/` root. Each component reads the
existing group from Azure where it needs a resource dependency. Locations,
names, tags and subscriptions are literal source values per U29/U30. This is a deployment
prerequisite, not an automatic dependency across separate Terraform roots.

| Owner | VNet range | Allocation and status |
| --- | --- | --- |
| Legacy shared network | `10.203.0.0/16` | Existing Terraform declares `TEAMY-NETWORK-VNET`; agents currently look it up. No changes in this phase. |
| Reference Architecture | `10.203.0.0/16` | New reference-owned network scaffold; gateway `.0.0/27`, private endpoints `.1.0/24`, agents `.2.0/24`. Staged range overlaps the legacy VNet; do not peer those two during transition. |
| Personal | `10.204.0.0/16` | Deployed and verified under 2.0b; gateway `.0.0/27`, private endpoints `.1.0/24`, AKS reservation `.4.0/22`. Live subscription preflight found no overlap with existing VNet/AKS ranges. |

New partition ranges do not overlap each other. This is not proof that either
range avoids every live VNet, AKS pod/service range, VPN or on-premises route.
Refresh that inventory before deployment or peering. Do not assign speculative
AKS pod/service CIDRs or change Benthic's network through this scaffold.

The fresh audit reports Benthic pod CIDR `10.244.0.0/16` and service CIDR
`10.0.0.0/16`; actual managed VNet/subnet and connected-route inventory remains
open. These observations do not change the proposed Personal address reservation.

Reference-owned allocation details live with the new reference networking root.
The old IPAM document remains a record of the still-active legacy network until
its consumers and Terraform ownership are deliberately transferred or retired.
The 18 October networking preflight also confirmed Benthic managed VNet
`10.224.0.0/12`, node subnet `10.224.0.0/16`, pod range `10.244.0.0/16`
and service range `10.0.0.0/16`; legacy shared VNet remains `10.203.0.0/16`.
No existing VNet peerings, local-network-gateway ranges or virtual-hub ranges
were present in this subscription inventory. This does not survey external networks.

## State transition protocol

| Existing backend | Keys established from source | Future treatment |
| --- | --- | --- |
| `CACN-Terraform-PROD-RG / terraformproddwvc87 / statefiles` | `teamdman.tfstate`, `azurewebsiets.tfstate`, `sfm-website-prod.tfstate`, `teamy-github-readme-stats.tfstate` | Preserve and inventory all consumers. `teamdman.tfstate` combines AKS, platform add-ons and hello, so splitting ownership needs a separate state migration. |
| Same legacy account | `TEAMY-NETWORK-RG - resource group.tfstate`, `TEAMY-NETWORK-RG - vnet.tfstate` | Retain until the shared network transition is decided. |
| `Teamy-Infrastructure-as-Code-RG / teamyiac / statefiles` | `resource-groups/Teamy-Infrastructure-as-Code-RG/resource_group.tfstate`, `resource-groups/Teamy-Infrastructure-as-Code-RG/storage_account.tfstate` | Preserve the existing self-hosted backend; no retargeting in this phase. |
| Reference architecture legacy backends | See the reference bootstrap guide for consumer categories and source searches; the exact per-root/blob/workspace manifest is still a deployment gate. | Separate reference ownership before pipeline backend cutover. |

There are three different operations to schedule independently:

| Operation | What changes | What stays the same |
| --- | --- | --- |
| Relocate a whole backend | Account/container location used by one existing Terraform root. | State contents, key, lineage, serial, resource addresses and Azure resource IDs. |
| Split or transfer Terraform ownership | Which root/address owns a resource, through a reviewed state mapping. | The live resource can stay in place; a backend copy alone does not perform the transfer. |
| Move an eligible Azure resource | Resource-group component of its Azure ID and associated access/configuration references. | Its Terraform tracking must be reconciled separately; a state-address rename does not move the Azure resource. |

Copying a whole state blob can relocate the backend for the **same** configuration
and resource addresses. It does not rename groups, adopt resources into new root
addresses or split combined ownership. Never let two independent roots manage
the same resource or write the same state key. Never copy the whole combined
`teamdman.tfstate` into each destination root.

Later, freeze all writers including Azure DevOps pipelines, preserve secure
backups and blob versions, record key/lineage/serial and checksums, copy each
intended blob without changing its content, verify destination identity and
network access, then reconfigure one consumer at a time. Keep keys unchanged for
whole-root relocation unless a separate mapping was reviewed. Retain rollback
blobs and the old account until every consumer uses the new backend. Do not allow
old and new writers concurrently during rollback. Splitting resources into the
new roots requires a separately reviewed address/ownership map.

For a whole-root relocation, prepare a manifest of root, writer identity,
source/destination account, container, blob key, workspace, remote-state readers
and reconciliation helpers. Include reference-owned `.devops_security.json`
marker blobs as data alongside the state; a missing generation marker can trigger
unintended reconciliation. Wait for each copy to complete and compare content
hashes and state identity. Blob versions, ETags and leases are not portable state
identity: record destination ETags independently rather than requiring old/new
ETags to match. Preserve historical versions securely as rollback evidence.

The destination is Entra-only. Two current reference backends omit
`use_azuread_auth`: `MyCoreProject/project/terraform.tf` and
`MyCoreProject/meta_pipeline/terraform.backend.tf`, relative to the Core
Infrastructure repository's `AzureDevOps/Projects/` tree. Audit and update those
and all other consumers during the later cutover. OIDC login alone does not select
Entra blob data-plane authentication. Verify the actual backend connection's blob
roles independently from the provider's resource deployment permissions.

After copying, backend declarations and working-directory backend caches both
need to be reconfigured in a later authorized session. Merely editing files does
not activate the destination. Preserve module/resource addresses for that first
backend switch; defer the combined Benthic state's split and resource moves.
Native blob locking protects each blob, not two copies in different accounts, so
keep the old owner frozen after the destination starts writing. Once the
destination has new writes, rollback must freeze again and reconcile the latest
state; simply pointing back at the stale source is unsafe.

See [HashiCorp's Azure backend documentation](https://developer.hashicorp.com/terraform/language/backend/azurerm)
and [backend initialization behavior](https://developer.hashicorp.com/terraform/cli/commands/init).
These are explanations of future work; no backend initialization, state command,
blob copy or state inspection was run in this follow-up.

Each new Azure root's key is reserved for its own new scaffold and is declared
literally in `terraform.backend.tf`; 2.0h removes the redundant examples.
Writing that source does not initialize a backend or migrate existing state.
The Personal state group's
`resource_group/` and `storage_account/` roots retain separate local states;
preserve both privately. U33 adds source imports for recovery without requiring
backend relocation. The two unused bootstrap remote examples are removed in
2.0h; they are not activated as backends.
Both bootstrap roots were deployed on 16 October and still use local backends.
Storage account
names have a separate lowercase alphanumeric constraint; dotted RG names do not
become storage account names. See [Azure naming rules](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules).

The Personal state account name is the literal `personalcorestatefile`; the
reference account is `refarchcorestatefile`. Both were available at preflight on
2026-10-16; Personal's account was subsequently deployed under 2.0. The reference
account remains undeployed and its name unreserved. Personal backend declarations
and reference examples use their respective literal names. The legacy random suffix remains provenance, not new state-account
configuration. Personal state/API access discovers the current operator's IPv4
through the HTTPS data source rather than committing an IP or requiring an
override variable. State bootstrap retains the deployed writer's literal principal
at the statefiles container and records the assignment ID in its import; a different caller does not
replace that grant. RBAC creation privilege, propagation and live
read/write/lease acceptance must be verified before remote-backend use.

## Keep reference agents available throughout the handoff

The current agents remain on `TEAMY-NETWORK-VNET` while a separately addressed
replacement VMSS/pool is prepared. Both networks use `10.203.0.0/16`; they do not
need peering to reach storage service endpoints, and they must not be peered to
each other. The new network has explicit NAT egress for Azure DevOps and downloads.

Before changing backends, allow both verified agent subnets on the required state
accounts and retain approved operator access. The new reference state scaffold
supports explicit old subnet IDs through `transitional_agent_subnet_ids`, in
addition to its required new subnet. It defaults to no legacy rules; supplying
verified old IDs is a migration precondition while old agents remain in service.

The legacy prerequisite account `terraformproddwvc87`, the new reference account,
`teamyhubazdoagentpool1sa`, and `teamymyfirstworkloadsa` need the approved transition
paths and per-identity blob grants. Both workload state roots copy the prerequisite
account's ACLs. Seed old and new paths on the new prerequisite and workload accounts
before repointing that copy source, or an ordinary subsequent deployment could
remove old-agent access. This is a documented later live change, not applied now.

Prepare a separately addressed VMSS and elastic pool with new-subnet Network
Contributor grants, a usable gallery/image dependency and project queue/service
connection authorizations. The current image, VMSS and pool deployment pipelines
themselves use the old pool, so retain it or a permitted operator bootstrap path.
Do not rebind its existing VMSS pointer and assume running jobs survive.

Run isolated canary checks on replacement agents before moving normal pipelines.
The existing healthcheck's blob listing in the agent account is insufficient:
verify every required account and each actual backend identity can read/list and
write/delete/lease a disposable probe blob, without touching real state. Verify
egress and queue/service-connection authorizations too. Those live probes require
a later authorized execution phase. Keep the old pool healthy through the writer
freeze and backend cutover, switch normal queues only after canary success, then
drain old jobs before removing old rules, identities or infrastructure.

The planned writer freeze pauses infrastructure deployments and reconciliation;
it does not require shutting down AKS workloads or the old agent VMs. Actual
deployment timings and access are unproven until live inventory and canaries.
The reference [bootstrap guide](../../Reference-Architecture/AzureDevOps/Projects/MyCoreProject/Repos/Infrastructure/bootstrap/README.md)
contains the detailed access matrix and consumer checklist. Locate that guide in
the sibling repository if the local checkout layout differs.

## Move azurewebsiets.net while preserving current traffic

Move the existing public zone from
`CACN-ClusterWorkload-Benthic-azurewebsiets-PROD-RG` into
`Personal.Workload.AKS.azurewebsiets.RG`. This is the same kind of Azure resource move
as the separately planned Raddest zone move; no Raddest change is made by this
phase. Do not replace the zone with an empty same-named zone.

Microsoft confirms that a DNS-zone RG move preserves its assigned nameservers and
DNS query service. Registrar NS delegation and current record values stay put for
the move. Moving the zone changes Azure resource IDs and requires a separate
Terraform/access reconciliation. See [Azure DNS move FAQ](https://learn.microsoft.com/en-us/azure/dns/dns-faq#can-i-move-an-azure-dns-zone-between-resource-groups-or-between-subscriptions)
and [resource move behavior](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/move-resource-group-and-subscription).

1. Inventory/export the complete live zone, all record sets, assigned nameservers,
   permissions, Terraform addresses and DNS automation. Source declares apex and
   wildcard A records with TTL 60, but that is not a complete live inventory.
   Keep both pointing at the current Benthic ingress during this operation.
2. Prepare the destination group through its single owning root and validate the
   exact Azure move scenario later. Freeze the owning Terraform writers and DNS
   automation for the move. Decouple the DNS destination RG from the legacy
   module's shared `resource_group_name`; changing the whole module input would
   also retarget storage, identity and unrelated resources.
3. Move the existing zone with its child record sets. Reconcile the new zone and
   record IDs against their intended single Terraform owner before another
   deployment. Current addresses are
   `module.azurewebsiets.azurerm_dns_zone.main`,
   `module.azurewebsiets.azurerm_dns_a_record.apex`, and
   `module.azurewebsiets.azurerm_dns_a_record.wildcard`. A whole-root backend copy
   can preserve these addresses initially; changing Azure IDs still requires
   state/provider reconciliation, not only an address-level move.
4. Recreate the zone-scoped DNS Zone Contributor grant for the existing certificate
   identity on the moved zone. Update both certificate Issuers'
   `azureDNS.resourceGroupName` to the destination. Verify authoritative/public
   DNS, unchanged delegation and record values, and a controlled certificate
   challenge before resuming automation. Plan for a management-write pause and
   role propagation while keeping existing certificates valid.
5. Handle identity and traffic migration separately. The current DNS user-assigned
   identity remains temporarily in the old workload group; do not assume it can
   move with the zone. Prepare replacement identity permissions and overlapping
   old/new AKS federation before changing client IDs. Switch ingress A records
   only after the replacement workloads and certificates pass checks; retain the
   old ingress and trust for the agreed rollback period.

The zone declaration, record declarations and issuer solvers currently derive
their group from the same legacy module resource group. Source references are
`modules/azurewebsiets/azure_dns.tf`, `azure_identity_dns_contributor.tf`, and
`kubernetes_issuers.tf` in `net.azurewebsiets.iac`. Its external-dns Helm file is
commented out; inspect actual automation before claiming an active controller.
Microsoft's [move support matrix](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/move-support-resources#microsoftmanagedidentity)
lists user-assigned managed identities as unsupported for RG moves; their
replacement is a distinct lifecycle decision.

## NGINX and workload cutover findings

The hello module uploads `content/index.html` containing “Ahoy, world!” to
`webcontent/index.html`. The Kubernetes Deployment mounts that container at
`/usr/share/nginx/html` using `blob.csi.azure.com` and a storage-key Secret. Its
`frontend` Service has type `LoadBalancer`; its hostless `/` Ingress also reaches
the shared `ingress-nginx` controller. Preserve the content and both routing paths
until a deliberate decision about the redundant public Service.

The controller and cert-manager are shared platform add-ons, separate from the
hello workload. Source module addresses are `module.benthic_cluster`,
`module.ingress_nginx`, `module.cert_manager` and `module.nginx_hello` in the same
legacy state. A destination RG shell does not migrate these resources.

Per U42, hello storage and runtime belong to `Personal.Workload.AKS.NGINX-Hello.RG`.
Its `resource_group` root owns that group once; `storage_account` and `kubernetes`
are independent siblings. Shared ingress/certificate add-ons remain in Core AKS.
Preserve storage contents and credentials while reviewing the later physical
storage move, existing ARM-ID imports and legacy state/ownership handoff.
The runtime deliberately reads the account in its legacy RG during overlap.
Both normal groups remain separate from AKS's managed node resource group.

Azurewebsiets and SFM point DNS at the ingress controller and federate certificate
identities against Benthic's OIDC issuer. A replacement cluster requires new
issuer bindings and tested certificates before switching traffic. SFM also has
registrar integration that can overwrite nameservers. Stats has a Key Vault and
GitHub token flow; its existing configuration can invoke 1Password during data
evaluation. Do not copy that evaluator into an active scaffold or persist secret
values in docs. Keep content, keys, certificates, registrar state and private
Terraform state secure throughout migration.

Stats' `github-readme-stats.teamdman.ca` A record is a manual registrar dependency,
outside its Azure Terraform root. Its Key Vault enables purge protection with
90-day retention. Do not treat an empty replacement vault as a copy of its data.

| Legacy source | Important resource addresses for the later ownership map |
| --- | --- |
| Cluster module | `module.benthic_cluster.azurerm_resource_group.main`, `module.benthic_cluster.azurerm_kubernetes_cluster.main`, `module.benthic_cluster.azuread_group.admins`. |
| Shared add-ons | `module.ingress_nginx.helm_release.main`, `module.cert_manager.helm_release.main`, their `kubernetes_namespace.main` resources, and `null_resource.helm_repo_cert_manager`. |
| Hello module | `module.nginx_hello.azurerm_resource_group.web`, `.azurerm_storage_account.web`, `.azurerm_storage_container.web`, `.azurerm_storage_blob.index`, `.kubernetes_secret.storage_key`, `.kubernetes_deployment.nginx`, `.kubernetes_service.frontend`, `.kubernetes_ingress_v1.frontend`, `.kubernetes_namespace.main`; root `random_string.suffix`. |
| Azurewebsiets | Resources remain under `module.azurewebsiets`; enumerate all addresses from private state before splitting or moving. `helm_external_dns.tf` is commented out, so it is not proof of a deployed external-dns controller. |
| SFM | Root `azurerm_resource_group.main`, `azurerm_storage_account.main`, `azurerm_storage_container.main`, `azurerm_dns_zone.main`, DNS A records, cert-manager identity/federation/role, `namecheap_domain_records.main`, and Kubernetes resources. |
| Stats | Root `azurerm_resource_group.main`, `azurerm_key_vault.main`, `azurerm_user_assigned_identity.main`, `azurerm_federated_identity_credential.main`, Key Vault roles/secret and Kubernetes resources. |

This is a source-level inventory, not an executable import map. The new
destination-group addresses do not claim ownership of existing groups.

## Readiness and cutover gates

G8 is the complete-source gate before any deployment. Other gates distinguish
design/preparation from live evidence: infrastructure and restore tests requiring
a candidate are completed during Phase 2 before the relevant cutover/retirement.

| Gate | Required decision or evidence | Acceptance consequence |
| --- | --- | --- |
| G1 — backend ownership | Exact per-partition blob/workspace/marker manifest, writers/readers, Entra blob auth, RBAC, operator access, account names and bootstrap-state custody. | No empty backend mistaken for existing ownership; writer freeze, verified copy/cache reconfiguration and current-state rollback. |
| G2 — reference network transition | Verified old/new subnet bridge on all required state accounts, actual identity/queue access, independent replacement VMSS/pool and image dependencies. Review any alternate adopt/move approach separately. | Existing pool remains healthy, candidate passes canaries, queues switch and jobs drain before old paths retire. No peering of overlapping VNets. |
| G3 — AKS replacement | Current cluster/node pools, supported version, SKU/quota, admin identity, explicit outbound path, ingress IP/DNS, storage, pod/service ranges and replacement topology. | Rebuild and cut over; do not attempt an in-place AKS/RG/VNet move. |
| G4 — CloudTerrastodon test removal | Live inventory found only vault arbitraryname; user selected removal with no replacement. Verify secret custody, dependencies, old ownership and deletion scope later. | No new destination or redeployment. No deletion in Phase 1. |
| G5 — AI retirement | Verify dependencies, retained data and deletion scope after this phase. | No AI redeployment; deletion remains outside offline scaffold. |
| G6 — azurewebsiets DNS move | Full live zone inventory, same-subscription move validation, single Terraform owner and updated IDs, zone RBAC, solver RG, retained identity/delegation. | Existing zone/records move without changing ingress targets; DNS and certificate checks pass before automation resumes. Raddest's separate plan remains separate. |
| G7 — complete workload restoration | Before replacing data: preservation/restore mapping, complete blob inventory/backup, secret custody, image/version choices. After candidate deployment: replacement HTTP/HTTPS/API/certificate and data acceptance tests. | Preservation readiness precedes data replacement; full restore acceptance gates traffic cutover and retirement, not construction of the candidate needed for those tests. |
| G8 — complete source before deployment | All agreed migration Terraform, component input/output contracts, state/resource ownership maps, preservation/cutover procedures and validation evidence exist; material scope decisions are closed or explicitly deferred by the user. | No foundation, candidate or other deployment begins while required source is missing. Deploy-time outputs may be unknown through explicit contracts. Passing G8 does not itself lift the validate-only command limit. |

[Microsoft's AKS FAQ](https://learn.microsoft.com/en-us/azure/aks/faq) states that
moving/renaming AKS and associated resources, or moving a cluster to another VNet,
is unsupported. The managed node RG shares the cluster lifecycle. Eligible DNS
or storage resource moves need their own
[resource-type support check](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/move-support-resources)
and dependency validation; do not generalize from one resource type to another.

## Phase 1 — complete all migration Terraform (source complete)

### [x] 1.1 Trace ownership and preserve requirements

**Completion notes:** Source roots, user disposition matrix, legacy backend keys
and NGINX content path are recorded above. The three user-named repository
worktrees were clean at the start. No resource state, secrets or live cloud
inventory were read as evidence.

**Validation:** Scoped `rg` searches and source reads across the named repositories
and directly referenced SFM/Stats IaC. Historical findings are explicitly labeled.

**Completion criteria:** Every provided group and naming decision has a disposition.

### [x] 1.2 Scaffold Personal boundaries and state/network foundations

**Completion notes:** At initial scaffolding, seven new roots contained 49 Terraform source files:
`Personal.Core.StateFile.RG/bootstrap`, `Personal.Core.Networking.RG/networking`,
and five `resource_group` roots for AKS, SFM, azurewebsiets, NGINX and Stats. All
seven passed `terraform validate` on 2026-10-15 using the existing locked
AzureRM 4.81.0 and HTTP 3.6.0 packages. Only lockfiles and provider package trees
were reused; no backend metadata or state was copied. Sandbox provider RPC
failures were resolved by running the same read-only validate commands elevated.
Six destination backend examples have distinct keys, and ignored private inputs,
backend files, state and provider caches were checked with `git check-ignore`.
Existing Terraform roots are unchanged.

**NGINX ownership correction (U22):** The initially proposed separate NGINX
destination is superseded by `Personal.Core.AKS.RG`. Its unapplied RG-only root
and backend example were removed after verifying that the generated directory
contained no tracked content, state, plans, private inputs or reparse points.
After this correction, the scaffold had six Personal roots, 43 Terraform source
files, four destination RG shells and five destination backend examples. Original validation
counts above remain historical evidence; no live resource or state was removed.
The updated AKS RG root passed
`terraform -chdir=sub/aafc/rg/Personal.Core.AKS.RG/resource_group validate -no-color`
on 2026-10-15 using its cached provider outside the sandbox. No other Terraform
command ran for this correction.

**Sibling-root correction (U23/U24):** The unapplied Personal combined bootstrap
and networking roots have been replaced by sibling units:
`Personal.Core.StateFile.RG/resource_group`,
`Personal.Core.StateFile.RG/storage_account`,
`Personal.Core.Networking.RG/resource_group`, and
`Personal.Core.Networking.RG/vnet`. Group roots contain only RG resources;
the account/VNet roots use `data.azurerm_resource_group.this` and derive the
group's name and location; U29 later makes tags literal in each root.
StateFile's two roots use distinct local states;
networking's two roots have partial remote backends. All eight roots at that foundation stage
have distinct future/example backend keys. Existing state, resource addresses
in deployed roots and legacy backends were not moved.

The old combined source directories were checked for runtime state, private
inputs and reparse points before the local-only moves. Recursive
`cloud_terrastodon.exe terraform reflow --recursive <Personal-group-directory>`
ran successfully on each of the six Personal group trees using the installed
tool's default per-block layout, without `--full` principal lookups. All eight
resulting roots passed `terraform validate -no-color` on 2026-10-15 using trusted
cached providers outside the sandbox. No other Terraform executable command ran.

**Work:** Add independent bootstrap, networking and destination-group roots under
`sub/aafc/rg/Personal.*`; leave legacy roots unchanged. Exclude AI and defer
unverified test payloads. Avoid stale AKS version and secret evaluator copying.

**Validation:** Run only `terraform "-chdir=<root>" validate` with existing local
providers; compare new CIDRs and state keys; inspect Git diff for legacy edits.

**Completion criteria:** Bootstrap/network resources and destination groups are
concrete, separately stateful and clearly distinguish payload migration still to do.

### [x] 1.3 Scaffold reference-owned prerequisites

**Completion notes:** The reference Infrastructure repository now has independent
`bootstrap/networking`, `bootstrap/statefile` and
`bootstrap/destination_resource_groups` roots. All three passed
`terraform -chdir=<root> validate -no-color` on 2026-10-15 with existing AzureRM
4.81.0 and AzAPI 2.9.0 packages and matching lock selections. Only these new roots
use the compatible bounded constraints; existing provider requirements are
unchanged. Provider packages were seeded offline without backend metadata,
downloads or initialization. Sandbox provider RPC failures were resolved with
the same read-only validation outside the sandbox.

The network includes Storage/Key Vault endpoints and explicit NAT egress for new
agents. The state account has default-deny private operator rules, the new agent
subnet rule, Entra-only blob authentication and explicit writer grants. IPAM and
cutover guidance live in `bootstrap/README.md` and
`bootstrap/ip-address-management.md`. English and French overview/maintenance
docs link to the scaffold. No active Terraform, YAML or registration file changed.

**Follow-up evidence (2026-10-15):** Added optional
`transitional_agent_subnet_ids` to the new reference state account so explicit
legacy subnet rules can coexist with its required new-subnet rule. The changed
state root passed `terraform -chdir=<statefile-root> validate -no-color` with the
cached providers outside the sandbox. Only this changed root needed validation;
the original ten-root pass remains historical evidence. No bridge rule is live
until a later authorized deployment supplies verified IDs and applies it.

**Work:** In the reference repository, add unregistered bootstrap state/network
roots, target group boundaries, IPAM and a consumer/cutover inventory. Preserve
active backends, pipeline registrations and subnet lookups.

**Validation:** `terraform validate` where cached providers permit; static checks
that active roots and registrations did not change. No pipeline queue or publish.

**Completion criteria:** Reference foundations can be reviewed independently from
Personal, with backend/network transition gates visible.

### [x] 1.4 Review both scaffolds and record validation

**Completion notes:** Both repositories pass `git diff --check`; new Terraform,
lock and example files pass explicit whitespace checks. A generic CIDR check
proved each partition has three contained, non-overlapping subnets and that the
two partition `/16` ranges are distinct. It deliberately does not prove live
route/pod/service compatibility. The six initial Personal backend example keys were
unique. `git check-ignore` confirmed private state, backend inputs, variable files
and provider caches stay untracked while examples remain visible.

An independent source review found no material scaffold blocker. Its variable
file loading correction is resolved with ignored `operator.local.auto.tfvars`
examples in the reference guide. Git checks confirm the three named source
repositories had no pre-existing edits at the start, existing Personal Terraform
roots and reference Terraform/YAML remain unchanged, and Cloud-Terrastodon is
unchanged. The three intent-audit passes above are complete. No cloud mutation,
deployment, state operation or Terraform command other than `validate` ran.

The walkthrough follow-up adds U18/U19, G6 and 2.4 for the explicit public-zone
move, fixes the old/new agent handoff gap, and records the two missing Entra-auth
backend settings and shared ACL-copy dependencies. The intent audit above was
repeated against both user messages. Documentation/source consistency checks
cover this follow-up; live DNS, state-copy and agent continuity remain unproven.

U22 originally removed the unapplied NGINX-only destination root and placed storage
ownership in Core AKS; U42 later supersedes that boundary in 2.0j. The then-current
five Personal backend example keys remained distinct; that historical ownership summary excluded a separate NGINX group. This
correction makes no cloud, state or pipeline change.
`git diff --check` and current root/file/key counts pass. No active source or
summary retains the superseded destination; its name remains only in the ledger
as the explicitly superseded proposal. Existing tracked Terraform roots are
unchanged.

U23/U24 introduced eight Personal roots at that foundation stage, with six RG-only owners and two
component roots. Deployment order is StateFile `resource_group` →
`storage_account`, then each remaining `resource_group` → its component roots.
The former combined bootstrap/networking source paths and their prospective
keys are historical only. Reflow split variables, outputs and Terraform settings
into the requested filenames before validation. This is a source restructuring,
not a state migration or Azure change.
The foundation-stage static checks found 88 Terraform files across eight roots, six RG-only
owners, two component roots and eight distinct backend-example keys. Comparing
the saved pre-reflow sources with the result preserved all 64 non-Terraform
top-level block identities and their root placement. Independent read-only review
found no material issue with group lookups, deployment order or local-state
custody. Existing tracked roots are unchanged and `git diff --check` passes.

**Work:** Review naming, data/state custody, IPAM, ignored/private inputs and
legacy preservation. Complete the three-pass intent audit.

**Validation:** `git diff --check` in each edited repository, provider-backed
`terraform validate` for new roots where possible, static topology/key checks.
Record limits; validation is not a deployment plan.

**Completion criteria:** No unauthorized command or cloud mutation; scaffold
results and outstanding gates accurately documented.

### [x] 1.5 Audit live application presence and storage references

**Completion notes:** Fresh read-only Kubernetes/API discovery and Azure AKS
properties queries succeeded using the existing context/session outside the
sandbox on 2026-10-15. The latest sanitized snapshot has 476 objects plus 26 Secret
metadata entries, zero failed query groups. All four expected app Deployments are
1/1 ready; Services, Ingresses, ConfigMaps, service accounts and Issuers match the
source-level application inventory. No extra application workload was found in
the queried resources, and there are no PVC/PV, StatefulSet, Job or CronJob objects.
Field-manager provenance supports Terraform/Helm ownership. The separate
[audit report](aks-live-audit.md) records scope, image IDs, version drift and limits.

**Work/validation:** Compare sanitized object identities and selected references
against the four legacy source roots and shared Helm definitions; inspect Secret
metadata only. Private evidence and the collector remain ignored under
`ignore/aks-audit/`. No Terraform command, remote execution, cluster mutation or
data/secret export occurred. This completes live inventory, not a restore test.

**Completion criteria:** Application presence and selected dependencies are
evidence-backed; any claim of full restoration remains behind G7/2.5.

### [x] 1.6 Implement Personal AKS, maintained ingress and NGINX hello

**Completion notes:** Added `aks`, `ingress`, `cert_manager`,
`nginx_hello_storage` and `nginx_hello` beside the Core RG owner at that time;
U42/2.0j subsequently moves hello into its own workload siblings. AKS pins the
regionally available 1.35.8 patch, Azure CNI Overlay, explicit outbound path,
Blob CSI, Entra groups/RBAC and restricted API inputs. Pod/service ranges are
10.242/16 and 10.243/16. Traefik replaces ingress-nginx per U27; its original
chart 42.0.0 source was superseded by direct Kubernetes resources in U37/2.0e.
The same Traefik v3.7.14 runtime is pinned by verified image digest. The original
cert-manager chart v1.21.2 is superseded by direct version-matched resources in
U39/2.0g. The original node/image/operator input contracts were
subsequently simplified under U30/1.11 into fixed literals and operator-IP discovery.
Hello retains both direct LoadBalancer and hostless Ingress routes and reads
retained blob data during overlap. Storage imports target the original account/
container after their then-planned Core RG move, with no blob upload. The current
destination and exact old addresses/ownership releases are in the NGINX workload
README after 2.0j. Recursive reflow and all five new
root validations passed; independent reviews checked Blob CSI auth, candidate
context guards, service fields and workload HTTP/TLS/challenge routing.
See `ingress-transition.md` and `phase-1-source-map.md`; live proof remains Phase 2.

**Work:** Extend the RG-only Personal scaffold with actual replacement AKS,
shared ingress/certificate add-ons and the hello workload. Choose a supported,
available cluster version and explicit network/identity settings using current
evidence when implementation begins. Map existing content, storage credentials
and ownership explicitly so the canary can retain the current hello Blob content
without replacing storage during the initial canary. Its final storage belongs
in `Personal.Core.AKS.RG` per U22, with the AKS RG owned once; plan the later
storage move/transfer and state mapping separately from the canary. Preserve old
states, DNS targets, Benthic and reference
agents. Treat this as the recommended next source slice, not a deployment.
Keep the group's existing `resource_group/` root as the only group owner; add
component roots as siblings with an Azure data lookup for the existing group.
Authoring `main.tf` is acceptable, followed by the U24 recursive reflow command
and `validate` in each affected root.

**Validation:** Review sources and run only `terraform validate` using available
matching providers/modules. Record any missing dependencies rather than running
initialization under the current limit. No new cluster or candidate traffic test
is claimed from validation alone.

**Completion criteria:** A concrete, reviewable candidate cluster/add-on/hello
configuration exists, external dependencies have preservation mappings, and its
validation result/limits are recorded. Later, the first Personal cloud deployment
establishes state and network foundations before creating that candidate; it does
not require first changing reference backends or agents. This source slice alone
does not authorize or make an early canary deployment ready; G8 covers all source.

### [x] 1.7 Complete the remaining Personal workload and move configuration

**Completion notes:** SFM and Azurewebsiets each have storage, DNS, DNS-identity,
Kubernetes and certificate siblings. Declarative imports require the original
post-move accounts/zones/managed records, with prevent_destroy; required traffic
values preserve Benthic routing until cutover. Retained writer grants, original
webcontent and external registrar delegation are mapped. Stats has vault
adoption, identity, runtime and certificate siblings, the audited image digest,
retained-token reference, old-reader bridge grants, Traefik HTTPS/HTTP01 routes
and no secret evaluator. Exact legacy addresses and staged freeze/move/adoption
procedures are in each group README. All 14 new workload roots were recursively
reflowed and validated. U28 closes the test-destination question by selecting
later removal with no replacement; read-only inventory verified its sole vault.

**Work:** Write the SFM, Azurewebsiets and Stats component Terraform beside their
RG owners, including storage/content input contracts, identity/federation, DNS,
certificate settings and intended images. Prepare zone-move and state/ownership
reconciliation mappings without retargeting active deployments. Resolve the test
group's disposition (now later removal per U28); retain AI as a
separate retirement decision without redeployment code.

**Validation:** Reflow changed group trees and validate every affected root with
available providers/modules. Review source coverage against the live audit and
preservation requirements. Record missing dependencies as incomplete evidence.

**Completion criteria:** All agreed Personal migration components and contracts
are concrete, not RG-only placeholders; no deployment or traffic change occurred.

### [x] 1.8 Complete reference handoff source and transition mappings

**Completion notes:** Added the separate reference
`bootstrap/transition/{storage_access_bridge,agent_vmss,agent_pool}` roots.
The bridge preserves current ACLs while adding both agent paths across four
state accounts and selected missing writer grants; unsupported IPv6 rules fail
closed. Candidate deployment/pool-management identities receive explicit new-RG,
subnet and pinned-image permissions. Separate queues and pipeline-specific
authorizations avoid changing active routing. Pool management requires a verified
supported endpoint; the old workload-identity service connection is not assumed
eligible for a fresh elastic pool. Job/backend WIF remains a separate contract.
An exact source manifest covers 37 state keys (28 prerequisite, nine retained),
14 reader files, two security marker keys and 38 normal pool-route files.
The offline generator changes only ignored candidate source: 48 consumer files,
or 86 with the later normal-route stage. Independent review compared all 53
state/reader/marker entries with zero key changes. Partial backends are recorded
separately so committing the new scaffolds does not invent source state blobs.
All three authored roots passed recursive reflow and validate after review fixes.
Active source, backends, agents, queues and pipelines remain unchanged.

Generated copies of existing consumers were checked for literal/key preservation,
not provider-validated. They retain existing module/provider requirements and
must be regenerated from current source with actual foundation outputs and
validated per root before promotion. This is an explicit Phase 2 activation gate;
no generated tree has been promoted or initialized. See the reference transition
README and consumer manifest for exact file/key scope.

**Work:** Prepare reference candidate-agent and consumer changes, backend auth,
old/new subnet access, queue/identity/image dependencies and exact state/marker
maps. Keep active defaults and writers on their old paths until the reviewed
Phase 2 handoff. Code and contracts for that handoff must exist in Phase 1.

**Validation:** Static consumer/ownership review, reflow and `validate` on affected
roots where providers/modules are available. Live probes and writer freeze are
Phase 2 work and are not claimed from source validation.

**Completion criteria:** Reference migration code and its staged cutover mapping
are reviewable; existing agents and backends remain unchanged.

### [x] 1.9 Review complete source before allowing deployment planning

**Completion notes:** The 2026-10-15 final pass ran
`cloud_terrastodon.exe terraform reflow --recursive` on all six Personal group
trees, then `terraform validate -no-color` in every Personal root. All 27 exited
0 without warnings. Final source inventory: 416 Terraform files, 27 distinct
backend-example keys and six RG declarations, all under resource_group siblings.
Independent reviews confirmed all four audited application shapes, protected
persistent-resource adoption, exact legacy address maps, no source blob
overwrites/secret evaluators/registrar writes/provisioners, explicit candidate
contexts, Traefik TLS/redirect/HTTP01 behavior in source, and old/new DNS/vault
reader grants. The three reference transition roots also passed post-fix
reflow/validate. The previously validated three reference foundation roots remain
unchanged in this slice.
Private command evidence is in ignored `ignore/phase-1-validation/`; it contains
root paths and validate output, no cloud state or secret values. U01–U28 were
checked through extraction, traceability and adversarial omission passes.
G8 is complete for source scope. Live move/restore tests, image acceptance,
actual identities, generated-consumer activation validation, writer freezes and
all deployment/cutover/deletion actions remain Phase 2 gates. No command beyond
Terraform validate, no cloud mutation and no deployment occurred.

**Work:** Close G8 after 1.6–1.8. Check every migrate entry, required resource,
component contract, state key, preservation procedure and staged handoff. Treat
missing code or unvalidated dependencies as unfinished; distinguish legitimate
future output IDs from missing implementation.

**Validation:** Source coverage, recursive reflow, required configuration
validation and a review of the Phase 2 execution/rollback order. No Terraform
command beyond `validate` is authorized by this check.

**Completion criteria:** All migration source is written/reviewed and its limits
are visible. Deployment authorization remains a separate later step.

### [x] 1.10 Replace subscription and tag inputs with literals

**Completion notes:** U29 fixes the subscription to the existing
`6cb7032f-2437-4f5e-91e8-676cb67e5444` in provider settings, certificate solvers,
resource/import-ID validation and backend examples. All Azure resource tag maps
in the new scaffolds are literal maps preserving their previous fixed values;
there is no additional-tags input or inherited/local tag lookup. Removed 23
Personal subscription variable files and six tag variable files, plus five
reference subscription declarations. At that checkpoint, Personal had 387 Terraform
files across the same 27 roots and 27 distinct backend keys. Obsolete tfvars
assignments were removed.
The reference destination RG declarations are separate literal resources with
the same names and output keys; none of these new groups is deployed.
Recursive reflow ran on all six Personal trees and the reference bootstrap tree.
All 27 Personal and all six reference roots passed validate using cached providers.
No other Terraform command, state/backend initialization, cloud mutation or
deployment occurred. Other required migration inputs remain intact.

**Validation:** Scan for subscription/tag variable declarations/references,
nonliteral tag assignments and obsolete input examples; review preserved literal
values and unique state keys; recursive reflow followed by per-root validate.

**Completion criteria:** Subscription/tag input declarations and their uses are
absent from new scaffolds; literal values are consistent and validation passes.

### [x] 1.11 Minimize fixed-value indirection across the migration source

**Completion notes:** Applied U30 to every new Personal root and all six reference
bootstrap/transition roots. Regions are literal canadacentral; fixed storage
names, vault/token names, Kubernetes contexts, versions, sizes and image digests
are literal values. Personal variable declarations fell from 85 to 12; current
source has 324 Terraform files across the same 27 roots/keys. The six
RG owners and every storage root have zero variable inputs. Generated OIDC and
managed-identity metadata use fixed-name Azure data lookups rather than copied
output variables. Old resource-group lookups are explicit source literals for
the canary stage; edit them after the approved moves rather than parameterizing
every root for hypothetical deployments.

The new state names personalcorestatefile and refarchcorestatefile passed
read-only availability checks. Existing hello/SFM/Azurewebsiets account names and
the AKS admin group were verified through read-only Azure metadata. AKS now
selects one Standard_D4s_v5 system node, verified listed without regional SKU
restrictions; review cost/quota before execution. Static frontends pin the
official nginx stable-alpine OCI digest
sha256:970364228b1e4f932abc22d321932816782cca8a20b85a77552a7cfe9acfb3b5;
registry metadata confirmed Linux amd64, but no image was pulled or served.
State and AKS discover operator IPv4 through HTTPS with validation, and the state
root declares a container-scoped Blob Data Contributor grant for its actual
bootstrap caller. No credential or resolved public IP is embedded in source.

Reference removed 18 fixed Terraform inputs; 11 genuine operational/security
contracts remain with reasons in its transition README. Its retained gallery
image 0.1.0 was verified present/succeeded with no purchase plan. The offline
consumer generator also uses the fixed new account ID and retains all 37 state
keys; active consumer source remains untouched.

| Remaining Personal declaration | Count | Actual purpose |
| --- | --- | --- |
| kube_config_path | 9 | Private credentials live at different paths on deployment machines. |
| traffic_ipv4_address | 2 | Preserve old website traffic during resource moves, then explicitly cut over; do not commit resolved public IPs. |
| acme_server | 1 | Stats has an actual staging-to-production certificate workflow. |

Added AGENTS.md so future edits preserve this deployment-root convention. Removed
obsolete input templates and updated component instructions/backend examples.
Recursive reflow completed on all six Personal group trees and the reference
bootstrap tree. All 27 Personal and six reference roots validated successfully;
the state root was reflowed/revalidated after the writer grant, without warnings.
No Terraform command beyond validate, deployment, state operation or cloud write
occurred. Live authorization, data restore, DNS and certificate acceptance remain
Phase 2 work.

**Validation:** Inventory all variables and justify each; check literal names and
locations, protected imports, independent backend keys and sole RG ownership;
use read-only metadata for existing names and source pins, recursive reflow and
per-root validate with cached providers. Independent Core review found no new
preservation blocker; stale docs and the state-writer prerequisite were corrected.

**Completion criteria:** Fixed configuration is literal; RG/storage roots are
input-free; remaining inputs have operational reasons and all source validates.

### [x] 1.12 Use main labels and one object output for RG/account owners

**Completion notes:** The six new Personal RG resources and four account
resources now use main, as do their matching RG/account data lookups. References,
import destinations, per-block filenames and migration maps were updated by the
source change and recursive reflow. Each RG root has one resource_group output
whose value is azurerm_resource_group.main. Each account root has one
storage_account output whose value is azurerm_storage_account.main, with
sensitive=true because the full object contains credentials. Separate ID/name/
container/group outputs were removed from these owners. Other component outputs
and actual Azure names/backend keys remain unchanged.

The source scan found no Personal terraform_remote_state consumers or references
to the removed scalar outputs, including the reference repository audit. These
roots remain unapplied; no state move/moved block was needed or executed.
Deployed legacy roots retain their existing addresses. Reference bootstrap labels
are already descriptive, and its backend_config remains an independent flat
backend contract rather than an RG/account owner output.

Recursive reflow ran on all six Personal group trees. All 27 roots passed
validate. Four account roots report AzureRM 4.81 deprecation warnings for fields
included by exporting the full object (queue_properties and static_website);
there are no validation errors. No account keys were read or printed. The source
now has 308 Terraform files, six RG object outputs and four sensitive account
object outputs. AGENTS.md records the convention. No other Terraform command,
deployment, state operation or cloud write occurred.

**Validation:** Check one output per RG/account owner, all primary labels main,
sensitive account objects, resolved references/imports, unchanged Azure IDs/keys
and absence of old-output consumers; recursive reflow and per-root validate.

**Completion criteria:** Each new RG/account owner exposes its whole resource
object under the main-label convention, with sensitivity preserved and source
validation passed; provider warnings are explicitly recorded.

## Phase 2 — Personal foundations and subsequent migration

U32 authorizes the first deployment, 2.0, after G8/1.9. It does not wait for
reference-agent canaries. Other deployments, candidate tests,
state copies, moves and traffic changes follow incrementally inside this phase.

Reference execution order is foundation/access bridge → independent candidate
agents → writer freeze/state cutover → normal queue switch/drain. Tasks 2.1 and
2.2 share this dependency sequence; their numbering does not authorize finishing
the backend switch before agent access is proven. The zone move in 2.4 can precede
the AKS traffic cutover in 2.3 because it preserves the old ingress IP.
The Personal candidate source slice in 1.6 can proceed independently of the
reference migration. G4 remains a separate CloudTerrastodon removal/custody
gate; full G7 acceptance requires a candidate and therefore gates traffic cutover
and retirement rather than candidate construction.

### [x] 2.0 Bootstrap the Personal state group and account first

**Execution authorization:** U32 permits the resource_group root, then
storage_account, plus their necessary initialization, saved-plan review,
application and access checks. No other root, resource move, backend relocation
or legacy state migration was executed.

**Completed 2026-10-16:** Applied `Personal.Core.StateFile.RG/resource_group`, then
its `storage_account` sibling using their exact reviewed saved plans. The first
created only the RG; the second created `personalcorestatefile`, the private
`statefiles` container and the current operator's container-scoped Storage Blob
Data Contributor grant. Both plans were create-only, with no updates, deletions
or replacements. Location is `canadacentral`; storage is Standard LRS, StorageV2,
HTTPS-only with TLS 1.2, public blob access disabled and a default-deny firewall
with only the reviewed operator IPv4 allowlist. Automatic Azure provider
registration is disabled; required Storage/Authorization providers were already
registered at preflight.

**State custody:** The two backends remain local and independent at
`ignore/bootstrap/Personal.Core.StateFile.RG/resource_group.tfstate` and
`ignore/bootstrap/Personal.Core.StateFile.RG/storage_account.tfstate`.
The ignored custody directory has NTFS inheritance disabled and access limited
to the operator, SYSTEM and local Administrators. Saved plans, full execution
logs and hash-verified state backups are held there. The whole account-object
output remains marked sensitive; no keys or resolved operator IP are committed.
Preserve both bootstrap states before any separately reviewed relocation.

**Validation:** Azure metadata confirms successful provisioning, the intended
storage/firewall settings, private container and exact container-scoped grant.
Entra-authenticated blob upload/download passed a content-hash round trip. A
finite blob lease was acquired, observed and released. The uniquely named
verification blob was deleted and its absence confirmed. Restricted custody ACLs
were checked. Sanitized acceptance evidence is in
`ignore/bootstrap/Personal.Core.StateFile.RG/verification/bootstrap-acceptance.json`;
full private evidence stays in that directory. Final post-apply plans for both
roots returned exit code 0 with no changes. Both current state files still match
their backups and are excluded from Git.

**Outcome:** Personal's state foundation is usable by the verified operator.
Existing remote states, workloads and reference agents remain in service; no
replacement reference agents were required for this bootstrap. Other Personal
roots may use the new backend only when their deployment is authorized and the
relevant writer has verified access.

### [x] 2.0a Add source imports for bootstrap state recovery

**Completion notes (2026-10-18):** U33 retains the two local backends and adds
active literal `import` blocks beside all four deployed resource definitions:
`azurerm_resource_group.main`, `azurerm_storage_account.main`,
`azurerm_storage_container.statefiles` and
`azurerm_role_assignment.operator_state_writer`. IDs were checked against the
existing protected bootstrap state; the container and its scoped grant use full
ARM IDs. The grant's deployed principal ID is a literal so another caller does
not replace the original writer. Its import records the deployed assignment ID;
Cloud Terrastodon intentionally removes the optional role resource `name`.
The now-unused bootstrap
client-config data source is removed. No user name, email, key or resolved IP is
persisted in these changes.

**Recovery contract:** Keep imports active with the existing authoritative state;
Terraform ignores already satisfied imports. If that state is genuinely lost,
recover one owner per root: RG first, then the storage sibling, with a reviewed
plan/apply that imports the existing resources. Do not run an independent second
state alongside the original owner. Preserve state backups; imports reconstruct
resource bindings, not state lineage, history or blob contents. Azure permissions
and firewall access remain prerequisites. The account still discovers the
executing operator's IP, so adoption can propose a firewall allowlist update and
is not guaranteed to be an import-only plan.

**Fresh-deployment contract:** If these Azure resources do not exist, comment out
all four import blocks while retaining their resource blocks. Verify the fixed
storage-account name is available, then deploy the RG before its storage sibling.
A fresh deployment generates a new role-assignment GUID; refresh that import ID
from the new deployment before keeping or re-enabling imports for future recovery.
An active import of a missing object fails rather than choosing creation.
Bootstrap remote examples remained unused at this stage and are removed in
2.0h. Relocating these local states is not a prerequisite for networking or replacement AKS.
Benthic's replacement cluster starts with fresh state. Any retained DNS/storage
ownership transfer remains a separate future operation.

**Validation:** Ran recursive Cloud Terrastodon reflow on
`sub/aafc/rg/Personal.Core.StateFile.RG`, then `terraform validate -no-color` in
both sibling roots. Both pass. The storage root retains the two known AzureRM
4.81 deprecation warnings from the requested whole account-object output.
Source review checks all four IDs/targets, fixed grant principal, zero new inputs and
unchanged local backend declarations. Hash comparisons confirmed both state files are unchanged from the
pre-edit baseline; sanitized source evidence is in the ignored custody file
`verification/imports-source-review.json`. No `init`, `plan`, `apply`, `import`, state command, backend
relocation or Azure mutation was run for U33; live empty-state recovery remains
untested. The 16 October provisioning/access/no-change evidence under 2.0 is
historical and is not presented as validation of these new imports.

**Intent audit:** Extraction reread U33's original request and the preceding AKS
state clarification against the retained U01–U32 ledger. Traceability mapped the
four deployed managed addresses and two local backends to code and both root
READMEs. Adversarial review checked missing objects versus missing state, role
principal drift under a different caller, current-IP firewall access, one-state
ownership, fresh-deployment commenting and the unchanged boundary on execution.
This source task is complete; no recovery/import execution is authorized here.

### [x] 2.0b Deploy Personal networking with fresh remote states

**Completion notes (2026-10-18):** Applied the reviewed RG saved plan first
(one create), then the reviewed VNet saved plan (four creates). Both applied
exact saved-plan hashes and contained no imports, updates, replacements or
deletions. Live Azure metadata confirms the RG, VNet and all three subnets
provisioned successfully with the exact expected ranges, AKS Storage endpoint
and disabled private-endpoint policies. No peerings or extra subnet/resource
associations were created.

Both states are in the intended distinct blobs in personalcorestatefile/statefiles,
with different lineages, serial 2 each and released backend locks. The complete
JSON from raw Entra-authenticated Azure blob downloads matched each protected
Terraform-pulled backup. Both final Terraform plans returned exit 0/no changes.
Hash comparison confirms the two local bootstrap state files are unchanged.
Private deployment evidence and backups remain ignored with restricted NTFS
custody. Evidence is in `verification/live-network-acceptance.json` and
`verification/state-acceptance.json` below the custody directory named below.
No AKS, peering, legacy state migration or reference-network/agent change ran.


**Execution authorization:** U34 permits Personal.Core.Networking.RG/resource_group
first, then its vnet sibling containing the VNet and three declared subnets.
This includes initialization, plan review/apply and verification using the new
Personal state account. AKS, peering and reference/legacy network or state changes
remain outside this slice.

**Readiness evidence before deployment (2026-10-18):** Confirmed the intended user/subscription/
tenant, absent destination RG and registered Microsoft.Network provider. The
live subscription VNet, AKS, route, gateway and virtual-hub inventory found no
conflict with `10.204.0.0/16`. Both intended blob keys were absent and readable
with Entra login before init. Both roots had no existing local state, workspace
states or initialized backend metadata. Independent source review found exactly
five intended managed resources and no legacy references. Providers disable
automatic registrations.

**Backend contract:** Both networking backend blocks now contain literal
account/container/tenant/subscription/key settings with Entra/CLI authentication.
They start new states in personalcorestatefile/statefiles at
`resource-groups/Personal.Core.Networking.RG/resource_group.tfstate` and
`resource-groups/Personal.Core.Networking.RG/vnet.tfstate`. No existing state is
copied or migrated. The two bootstrap roots remain local with their recovery
imports. Protected plans, execution logs, downloaded state backups and acceptance
evidence live under ignored `ignore/deployments/Personal.Core.Networking.RG`;
its NTFS ACL matches the restricted bootstrap custody directory.

**Expected resources:** RG Personal.Core.Networking.RG in canadacentral;
VNet Personal.Core.Networking.VNET at 10.204.0.0/16; GatewaySubnet 10.204.0.0/27;
PrivateEndpointsSubnet 10.204.1.0/24 with private-endpoint policies disabled;
AKSSubnet 10.204.4.0/22 with Microsoft.Storage service endpoint. No peering,
gateway, private endpoint, NAT, NSG or cluster is part of these roots.

**Validation and completion criteria:** Reflow and validate source; review each
saved plan for only its create actions before applying it. Verify live resources,
correct distinct remote keys and managed-resource counts, protected state backup
integrity, unchanged bootstrap local state and final no-change plans. Record
completion only after those checks pass.

**Intent audit:** Extraction captures RG-before-component order and the required
new state account in U34. Traceability covers both literal backend blocks and all
five addresses. Adversarial review excludes old shared-network writes, implicit
provider registrations, reused/combined state keys, accidental imports and AKS
scope expansion. Source decisions remain literals and do not introduce inputs.

### [x] 2.0c Add the networking state-account access sibling

**Completion notes (2026-10-18):** Applied the exact reviewed saved plan after an
immediate live-ACL comparison confirmed no stale policy snapshot. Azure reports
AKSSubnet Allow with state Succeeded. Every non-VNet ACL field, including the
operator IP rule, default Deny and bypass None, is unchanged from the private
baseline. The new root's final plan exits 0 with no changes. Bootstrap's separate
plan proposes zero managed-resource changes and retains the VNet rule; it only
refreshes the sensitive whole-account output. That output-only plan was not
applied, and both local bootstrap state hashes remain unchanged.

The new remote state contains one AzAPI updater at serial 2 in its distinct
intended key. Full raw Azure state JSON matches the protected Terraform-pulled
backup; the backend lease is released and Entra blob access still works. Final
evidence is in `verification/live-acl-acceptance.json`,
`verification/access-acceptance.json` and `verification/bootstrap-delegation-review.json`
below the custody directory recorded below. No RBAC, subnet, cluster, legacy or
reference changes ran. Runtime traffic from inside the VNet was not tested;
there is no deployed Personal VM/AKS workload in this slice.


**Authorization and design (2026-10-18):** U35 adds
`Personal.Core.Networking.RG/storage_account_network_access`. The new root reads
only ARM storage metadata, looks up the existing AKS subnet and applies one
`azapi_update_resource.statefile_vnet_access` to personalcorestatefile's ACL.
It does not create a second account or take over whole-account management.
Only AKSSubnet currently has Microsoft.Storage; gateway and private-endpoint
subnet reservations are not granted access by this component. Network permission
does not grant an identity Blob RBAC.

The updater preserves the complete current non-VNet ACL fields and existing
other VNet rules, retaining writable rule properties and stripping read-only
state. It contributes AKSSubnet Allow and matches list entries by ARM ID.
Bootstrap retains its secure creation/ongoing operator-IP/default policy and
ignores only network_rules[0].virtual_network_subnet_ids. This avoids two AzureRM
whole-ACL owners. Both roots must execute serially; immediately before applying a
saved plan, reread and compare the complete ACL with the reviewed snapshot and
replan on any change. Removing the AzAPI updater does not revoke its rule;
revocation requires a separate explicit reviewed ACL update.

**State and source:** The new literal Entra/CLI Azure backend uses
personalcorestatefile/statefiles at
`resource-groups/Personal.Core.Networking.RG/storage_account_network_access.tfstate`.
At completion of 2.0c there were 28 Personal roots: two local bootstrap, three configured remote
networking roots and 23 remaining partial remote roots. No new inputs; 12
operational variables remain. AzureRM4.81.0 and AzAPI2.9.0 are locked from existing
verified provider packages. Recursive reflow ran on Networking and StateFile;
both affected roots pass validate (bootstrap retains known full-output warnings).

**Pre-apply execution evidence:** Confirmed the intended subscription/tenant,
raw Storage2025-08-01 API, default Deny, bypass None, one operator-IP rule,
zero VNet rules and absent/access-permitted new backend key before init. The
saved plan contains exactly one updater tracked resource; its body targets only
networkAcls, all non-VNet fields exactly match the private baseline, and the
sole change is AKSSubnet Allow. No account, subnet or grant is created. Protected
plans, baseline ACL, logs and backups live under ignored
`ignore/deployments/Personal.Core.Networking.RG/storage_account_network_access`.

**Validation and completion criteria:** Recheck the live ACL immediately before
saved-plan apply; verify successful live subnet rule and every preserved field,
continued Entra state access, one managed updater in the correct remote blob,
complete protected backup equality and an empty final updater plan. A separate
bootstrap plan must propose no managed resource changes or removal of the subnet
rule; its sensitive whole-account output may need refresh. Do not write the
bootstrap local states merely to update that output.

**Intent audit:** Extraction preserves the exact sibling name/location and state
account target. Traceability covers source, selective bootstrap ignore, distinct
state key and this work item. Adversarial review excludes whole-ACL takeover,
loss of existing rule fields, silent broad-try fallback, missing service endpoints,
stale concurrent ACL snapshots, implied RBAC, automatic revocation and new AKS/
reference infrastructure. Source-only no-state bootstrap recovery remains intact.

### [x] 2.0d Deploy the new Personal AKS foundation

**Completion notes:** U36 authorizes the RG owner followed by its AKS sibling.
Both roots are deployed and backed up. Cluster init/validate and independent
saved-plan review passed. Azure rejected the original dotted managed-identity name before
cluster creation; corrected it to `Personal-AKS-ControlPlane` to follow the
[managed identity naming rules](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/manage-user-assigned-managed-identities-azure-resource-manager).
Reflow/validate and two independent reviews confirmed the fresh plan differed
only in that name; the corrected four-create plan applied successfully. Both backends use
Entra CLI authentication in `personalcorestatefile/statefiles`, with distinct
`resource-groups/Personal.Core.AKS.RG/resource_group.tfstate` and `aks.tfstate`
keys. No existing cluster state is copied. Provider auto-registration is disabled.
Protected plans, backups, logs and isolated credentials live under ignored
`ignore/deployments/Personal.Core.AKS.RG` with inheritance disabled at its root
and only the operator, SYSTEM and Administrators granted access.

Read-only Canada Central preflight confirmed Kubernetes 1.35.8, unrestricted
Standard_D4s_v5 and quota for one four-vCPU node plus a surge node. The retained
admin group exists and the operator is a member. The saved cluster plan creates
only the control-plane identity, Personal AKSSubnet Network Contributor grant,
Personal-AKS cluster and retained-group cluster-admin grant. The source keeps
local accounts/run-command disabled, operator-only API access, Azure CNI Overlay,
OIDC/workload identity, all declared CSI drivers and explicit outbound connectivity.
AKS creates `Personal.Core.AKS.Nodes.RG`; do not precreate it.

Azure readback confirmed Succeeded/Running and declared security/network/pool/
storage settings. The isolated private kubeconfig targets the verified cluster
FQDN and the node provider ID points to the Personal managed node group. One
node is Ready, all seventeen system pods are healthy, CoreDNS is present and
Blob/Disk/File CSI node components and CSIDriver registrations exist. No user
add-on or workload was installed in this AKS-only slice; 2.0f subsequently
deploys Traefik. This proves cluster readiness, not application
restore, public ingress, certificates or a state-account access probe from its subnet.

Final `terraform plan -detailed-exitcode` returned 0 in both roots. Full Azure
state blobs equal protected Terraform-pulled JSON backups; RG serial 2 contains
one managed resource and AKS serial 6 contains four. Lineages are distinct and
both blob leases are released. Private plan/state/credential artifacts are
gitignored and their custody ACL passed verification. Both bootstrap local
states and all legacy state ownership remain separate.

Post-deployment Benthic checks found Succeeded/Running, one Ready node, all
twenty-four baseline controllers preserved and the four application Deployments
still at 1/1 ready. The global context remains `Benthic-PROD-AKS`. No Benthic,
reference-agent, DNS, workload or retained-storage mutation occurred.

**Work/validation:** Apply only the exact reviewed saved plans; verify Azure
provisioning and one Ready node through a separate private kubeconfig/context.
Check system controllers, final no-change plans, complete remote-state backup
equality, distinct state lineages and released leases. Read Benthic before/after
through its existing explicit context; preserve the global context. Its baseline
is Running, one Ready node and four application Deployments at 1/1 ready.

**Completion criteria:** Both new roots deployed with healthy cluster and verified
remote state; Benthic/apps remain healthy. No ingress, workloads, DNS switch,
retained-resource moves, old-state migration or reference-agent changes occur.

### [x] 2.0e Replace the unapplied ingress chart with direct Kubernetes resources

**Completion notes:** U37 replaces the ingress Helm provider/release with eight
typed Kubernetes objects (namespace, service account, role/binding, ingress class,
configuration, Deployment and LoadBalancer Service) plus ten vendored official
Traefik v3.7.14 CRDs. Runtime image digest, upstream CRD hashes/license and RBAC
are recorded in `ingress/` and `docs/ingress-transition.md`. CRD establishment
waits, destruction guards and deployment dependencies preserve lifecycle order.
The controller retains explicit class, HTTP/HTTPS, JSON logs, probes, non-root
security and configuration-checksum rollout. Workload Middleware roots follow
the established CRDs in a later authorized deployment.

**Validation:** Recursive Cloud Terrastodon reflow and Terraform validate passed
with Kubernetes provider 3.0.1. Independent source review checked CRD hashes,
RBAC, health endpoints, service ports, security and dependency order. No ingress
init, plan, apply or installation occurred during this source rewrite; U38/2.0f
subsequently authorizes and records deployment. No Helm state migration is needed
because the previous Personal ingress source was never deployed. The separate
cert-manager chart remained at this point and is subsequently replaced in 2.0g.

**Completion criteria:** Direct ingress source and documentation agree and
validate. Live rollout, LB probes, routes and certificates remain future tests.

### [x] 2.0f Deploy and verify the direct Traefik ingress controller

**Completion notes:** U38 authorized the ingress sibling on Personal-AKS only.
Its literal Entra/CLI backend uses the new account/container with fresh key
`resource-groups/Personal.Core.AKS.RG/ingress.tfstate`. Live preflight verified
the private kubeconfig endpoint/node group, healthy Personal node, unused state
key and absence of existing Traefik namespace/class/CRDs. A fresh Benthic baseline
captured its Ready node and twenty-four controllers, including four apps at 1/1.
Recursive reflow, init and validate passed with locked Kubernetes provider 3.0.1.
Parent and independent saved-plan reviews accepted exactly eighteen create-only
instances: eight typed objects and ten CRDs. The exact saved plan applied with
18 added, 0 changed and 0 destroyed. Protected plans, logs and state backups live
under ignored `ignore/deployments/Personal.Core.AKS.RG/ingress`.

Runtime acceptance confirmed one Ready/available Traefik v3.7.14 replica with
zero restarts and an image ID matching the pinned Docker index or its Linux
amd64 manifest. All ten CRDs are Established; the explicit non-default class,
static configuration, Local Service policy and ready EndpointSlice match source.
Actual service-account authorization permits required reads/watches and Ingress
status updates while denying Secret deletion and role-binding creation. The
controller log contains no error/forbidden entries. All cluster pods are Ready.
The initial log identified an unset alias-header policy relevant to the planned
NGINX backends. A second independently reviewed saved plan changed only the
ConfigMap and Deployment checksum, in place, to set
`http.aliasHeadersStrategy = "delete"` on all three entry points, following
[upstream entry-point guidance](https://doc.traefik.io/traefik/reference/install-configuration/entrypoints/#aliasheadersstrategy).
Reflow/validate and the rollout passed; refreshed runtime checks found one Ready
replica with zero restarts and no unset-policy advisory. The encoded-path
compatibility advisory remains part of the future G7 workload tests; logs are
not described as warning-free. No backend compatibility claim is inferred from
an empty controller's default routes.

Public HTTP and HTTPS on 80/443 return Traefik's expected default 404 without
installing application routes. The HTTPS handshake was tested with certificate
validation skipped; trusted workload certificates are not yet configured. The
dashboard is disabled and only 80/443 appear on the public Service. Read the
generated address through `terraform output load_balancer_ingress`; do not pin
it as a source value or change DNS in this slice.

The final plan returned exit 0. Complete remote-blob JSON equals the protected
pulled backup: eighteen managed instances at final serial 4, with a lineage distinct
from the Core RG and AKS states. The blob lease is released and private artifacts
are gitignored under restricted three-principal custody. Post-deployment Benthic
checks confirmed Running, one Ready node, all twenty-four baseline controllers
preserved and the four apps still at 1/1. The global context remains Benthic.
No workload, cert-manager, DNS, retained-resource or legacy-state change occurred.

**Work/validation:** Reflow and validate the root; review a saved plan containing
exactly eighteen creates, with no imports/replacements/deletes and the explicit
Personal-AKS provider context. Apply only that plan. Verify all ten CRDs
Established, Deployment 1/1 ready, pinned image and stable restarts, Service
80/443 with Local policy and ready endpoint, controller RBAC and clean provider
logs. Check the public HTTP default response and HTTPS handshake, without
creating application routes or changing DNS. Final plan must return exit 0;
verify complete remote-blob/backup equality, independent state lineage,
released lease and restricted custody. Compare Benthic controller/node health
and retain its existing global Kubernetes context.

**Completion criteria:** Direct Traefik is healthy and reachable on the new
cluster, with isolated verified remote state and Benthic/apps still healthy.
Workload routing, trusted workload certificates, cert-manager installation,
retained-resource moves and traffic cutover remain separate future work.

### [x] 2.0g Remove remaining Helm dependencies from Personal source

**Completion notes:** U39 requests flat direct Kubernetes Terraform across active
Personal source. Repository-wide scans found only the undeployed `cert_manager`
root's Helm release, provider, required-provider entry and lock entry. The
Reference-Architecture scan found none. Preserve old Benthic Helm addresses in
the ownership map; no live release or state is being converted. The root keeps
its own partial backend at this source-conversion stage and actual private
kubeconfig-path input; 2.0h subsequently supplies its literal Azure configuration.

The completed root has 53 reflowed Terraform files and 51 managed instances:
45 typed Kubernetes objects plus six official CRDs. It covers all 47 objects
in the pinned cert-manager v1.21.2 release and four dedicated admission-check
objects (ServiceAccount, Role, RoleBinding and tracked Job). The Helm release,
provider and lock dependency are removed; there are no modules, shell provisioners
or runtime installers. The raw pinned upstream bundle, Apache license, six CRD
checksums and five verified image digests are recorded under `cert_manager/`.
Full upstream bundle SHA-256 is
`e03b668ec8675214af6b0a671699d088f2601fa3878e0dbe1b41d3feafd1879f`.

The fixed namespace/service-account subject, outputs, workload identity pod
label and both ambient credential flags are preserved. Each existing Issuer
continues selecting its own Azure DNS identity; the controller ServiceAccount
does not acquire a shared identity annotation. Primary pinned webhook/solver
sources verify that label-only token projection and per-Issuer client selection
are supported. Runtime projection is still a later acceptance check.

CRDs wait for Established and have destruction guards. Typed RBAC/dependencies
sequence the webhook and cainjector before admission configurations and controller.
The webhook owns its generated CA Secret; cainjector owns only the two precisely
ignored CA-bundle fields. The final startup Job dry-runs a CertificateRequest
using scoped create permission, waits for completion with bounded retries/deadline,
and remains tracked without TTL. Component/admission/CRD changes trigger a new
check. This supplies an admission-trust gate before separate Issuer/Certificate
plans; it does not implement Helm atomic rollback.

Recursive reflow and cached Kubernetes 3.0.1 validation passed, including a
separate parent validation. Independent review accepted the CRD/upstream parity,
RBAC, CA ownership, dependency order, startup Job and identity contracts. Parent
inventory confirmed 45 typed objects/six CRDs, all recorded CRD hashes and an
uninitialized backend. Final active-source and lockfile scans found no remaining
Helm provider/release/helper dependency. Historical Helm source metadata in the
verbatim upstream CRDs is inert; Terraform guards their lifecycle. No init,
plan, apply, state operation, Kubernetes change or Azure mutation occurred.

**Work:** Replace the release with explicit Kubernetes resources based on the
pinned official cert-manager v1.21.2 definitions. Preserve the `cert-manager`
namespace/service-account federation subject, Azure workload-identity pod label,
ambient credential flags and existing outputs. Record every object and upstream
schema/license/hash; wait for CRDs and controller/webhook readiness. Keep
controller-generated webhook TLS material and injected CA bundles out of
Terraform ownership. Preserve staged workload Issuer/Certificate roots after
CRD/API readiness; no chart rendering, installer scripts or wrapper module.

**Validation:** Run recursive Cloud Terrastodon reflow and Terraform validate
against cached Kubernetes 3.0.1; independently review upstream object/RBAC/CA
injection coverage and dependency order. Scan all active Terraform and lockfiles
for Helm provider/release/helper use. Live admission, certificate and identity
checks remain part of the later authorized cert-manager deployment.

**Completion criteria:** No active Personal Helm dependency remains; the direct
cert-manager source and documentation agree and validate. No Terraform
init/plan/apply/state operation, Kubernetes change or Azure mutation occurs.

### [x] 2.0h Inline Personal backend configuration and remove redundant templates

**Completion notes:** U40 accepts upstream reference files and requests backend
cleanup. Twenty partial Azure backend blocks now contain fixed tenant,
subscription, state RG/account/container, the exact original unique key and
Entra/CLI authentication literals. Twenty-seven `personal.tfbackend.example`
files are removed, including two unused bootstrap remote references. There are
twenty-six fully specified Azure backends and two unchanged local backends;
only six Azure roots are initialized/deployed, with twenty still source-only.

Recursive Cloud Terrastodon reflow passed for all six Personal group trees.
Terraform validate passed in all twenty-eight roots using cached providers
(eleven Core and seventeen workload roots). Existing AzureRM full-storage-object
deprecation warnings remain; the cleanup changes no resource configuration.
Parent and independent reviews confirm exact preservation and uniqueness of all
twenty-six remote state keys, fixed Entra/CLI authentication and zero remaining
Personal backend templates.

Before/after hashes prove all eight deployed backend source files and all
initialization caches unchanged, both bootstrap state files unchanged, all 338
non-backend Terraform files unchanged, and all four accepted cert-manager
upstream reference files unchanged. Reflow added one blank line to a bootstrap
role file; restoring just that whitespace reproduced its exact baseline hash.
No init/reconfigure, state command, cloud call, deployment or migration occurred.
Current docs now use the single inline backend declaration and distinguish source
configuration from the twenty roots still awaiting deployment authorization.
Ignored source/hash inventory and validation evidence are under
`ignore/backend-cleanup/`; no raw state or credentials are copied there.

**Work/validation:** Preserve byte-identical source for the six existing Azure
backend blocks and both bootstrap local blocks. Compare cached initialization
metadata and both protected bootstrap state hashes before/after. Preserve all
non-backend Terraform and accepted upstream reference hashes. Reflow the six
Personal group trees, validate all twenty-eight roots with cached providers,
check exact key preservation/uniqueness and remove stale template instructions
from active docs. Historical earlier task descriptions retain their original
source-stage counts and examples as provenance; this task defines current setup.

**Completion criteria:** One literal Azure backend declaration per remote root,
no redundant Personal template/config files, unchanged state/backend pointers
and source/resources, coherent docs and successful validation. No Terraform
init/reconfigure/plan/apply/state command or cloud mutation occurs.

### [x] 2.0i Deploy cert-manager on the new Personal cluster

**Completion notes:** Deployed cert-manager v1.21.2 under U41 using direct
Kubernetes resources on the verified Personal-AKS endpoint and node group.
The fresh namespace/object preflight and state-key absence checks passed.
Initialization and validation succeeded; independent review accepted the saved
plan's fifty-one creates with no imports, updates or deletes. Applying that exact
plan added all fifty-one instances without changing or destroying resources.
Its literal Entra/CLI backend uses distinct key
`resource-groups/Personal.Core.AKS.RG/cert_manager.tfstate` in the new state
account/container. Protected plans, logs and backups are under ignored
`ignore/deployments/Personal.Core.AKS.RG/cert_manager`.

All three component Deployments are 1/1 Ready, with their reviewed image pins,
zero restarts and stable Pods. All six CRDs are Established. The retained startup
API-check Job completed, both admission CA bundles are populated, valid and equal,
and all nine positive/negative ServiceAccount authorization checks passed.
The controller has the expected readonly projected Azure token, matching tenant
and intentionally empty client ID for per-Issuer identity selection. No token or
private Secret contents were read; actual Azure token exchange/DNS solving remains
a workload acceptance check.

A uniquely labelled temporary namespace issued a self-signed `bootstrap.invalid`
certificate: Issuer and Certificate Ready, one CertificateRequest Approved and
Ready, revision 1. Guarded UID/label checks preceded deletion; the namespace and
all probe resources are absent afterward. No application Issuers, certificates,
routes, public CA requests or DNS changes were introduced.
Four transient cainjector not-found messages concerned the disposable probe's
Secret; a fresh sixty-second log check had no errors, forbidden or fatal messages.

The first final plan exposed AKS-added namespace exclusions on both webhooks.
Their source now explicitly matches `control-plane NotIn [true]` and
`kubernetes.azure.com/managedby NotIn [aks]`, retaining the original validation
opt-out and precise CA-bundle-only ignore. Scoped recursive reflow and validation
passed. The subsequent final plan returned zero changes without another apply.

Remote state has forty-six managed blocks containing all fifty-one planned
instances at serial 3. Complete pulled state equals a direct authenticated blob
download, its lineage is independent of the RG/AKS/ingress states, and the lease
is released. Protected inherited three-principal custody and Git ignores cover
plans, backups, logs and reused credentials. The remote blob stayed unchanged
during verification. At completion of this deployment, seven remote and two local
roots were deployed and nineteen remote roots remained uninitialized; 2.0j
subsequently adds one undeployed resource-group root.

Traefik's Deployment/Service UIDs, Deployment generation and public address are
unchanged, with controller Ready and HTTP/HTTPS default 404 responses (HTTPS
reachability used skipped certificate verification, not trusted host TLS).
Every active Personal Pod is Ready or completed. Benthic remains Running with one
Ready node, all twenty-four baseline controllers preserved and all four apps
ready. The global Kubernetes context remains Benthic. Reference agents, retained
resources, legacy state and traffic targets were not changed.

**Work/validation:** Confirm the private kubeconfig endpoint/node group and
fresh Benthic/Traefik baselines. Validate and independently review a saved plan
of exactly fifty-one creates with no imports/updates/deletes. Apply that exact
plan. Verify three Ready components, six Established CRDs, populated admission
CA bundles, completed startup Job and scoped permissions. Inspect only projected
token configuration/metadata, never token or private Secret contents. A scoped
temporary self-signed Issuer/Certificate probe may prove reconciliation; guard
namespace ownership and remove all probe objects afterward. Keep application
Issuers, external ACME/DNS and resource moves untouched. Require final no-change
plan, complete remote-state/backup equality, independent lineage, released lease
and restricted custody. Recheck Benthic/apps and Traefik/default context.

**Completion criteria:** Cert-manager is running with trusted admission and
verified fresh remote state, Benthic/apps and Traefik remain healthy, and no
temporary test resources remain. Real host certificates/DNS/workloads are future.

### [x] 2.0j Separate AKS workload groups and NGINX hello siblings

**Completion notes:** U42 supersedes U22's Core ownership and the old workload
prefix. The three existing workload folders and their seventeen roots now use
`Personal.Workload.AKS.SFM-Website.RG`,
`Personal.Workload.AKS.azurewebsiets.RG` and
`Personal.Workload.AKS.GitHub-README-Stats.RG`.
NGINX hello has a new `Personal.Workload.AKS.NGINX-Hello.RG/resource_group`
owner with `main`, literal values and one whole-object RG output. Its two
existing component roots move to the siblings below; storage adoption still
requires a separately approved real Azure move and ownership reconciliation.

| User-provided source reference, normalized to this checkout | New source destination |
| --- | --- |
| `<repo-root>/sub/aafc/rg/Personal.Core.AKS.RG/nginx_hello` | `sub/aafc/rg/Personal.Workload.AKS.NGINX-Hello.RG/kubernetes` |
| `<repo-root>/sub/aafc/rg/Personal.Core.AKS.RG/nginx_hello_storage` | `sub/aafc/rg/Personal.Workload.AKS.NGINX-Hello.RG/storage_account` |

These are source locations for the requested ownership change. The absolute
checkout prefix varies by machine; repository-relative paths preserve their
meaning without persisting machine-specific directory layout. No confirmation
was needed for these existing public source-relative names.

The twenty affected roots have new literal destination RGs/unique backend keys
and matching post-move ARM import IDs. Existing Kubernetes namespaces, runtime
names/images, account/container/vault/zone/identity names, and legacy storage/DNS
solver lookup locations are preserved. Runtime overlap reads continue against
the original resource groups until their separately approved moves.
Core retains only RG, AKS, ingress and cert-manager roots. At source-slice completion
there were twenty-nine Personal roots: two local and twenty-seven Azure backends,
with nine deployed roots and twenty uninitialized workload roots. A provider cache and
lockfile were copied for the new RG's local validation; no initialization ran.

Recursive Cloud Terrastodon reflow passed for all four workload trees. All twenty
affected roots validated with zero errors; the three storage owners retain the
existing AzureRM queue/static-website deprecation warnings from their sensitive
whole-account outputs. The final count/key audit passed: twenty-nine roots,
seven RG owners, twenty-seven unique remote keys, two local roots and no workload
backend initialization metadata. All 155 baseline hashes covering nine deployed
roots' Terraform/lock/backend caches and both bootstrap states are identical.
No active source retains the old workload names. General documentation links
resolve. Protected source audit evidence is under `ignore/rename-audit/`.

**Work/validation:** Reflow all four workload trees recursively; validate all
twenty affected roots against cached providers. Verify seven unique RG owners,
twenty-seven distinct remote keys, destination import consistency, unchanged
runtime/data/overlap contracts and no stale active source names. Preserve the
bytes of all nine deployed roots' Terraform/lock/backend-cache files and both
bootstrap local states against a private hash baseline. No Terraform init,
plan, apply, state/backend migration, live resource move or cloud command.

**Completion criteria:** Current source/docs agree on four AKS workload groups
and independent sibling ownership; reflow/validate and deployed invariants pass.
The refactor leaves Benthic and the new shared platform deployments untouched.

### [x] 2.0k Deploy the NGINX hello candidate using retained content

**Completion notes:** U43 followed the completed source slice 2.0j. Fresh target,
RG/object and state-key preflight passed for the verified Personal endpoint/node
group. The Blob CSI node driver supports Ephemeral volumes/PodInfoOnMount, is
Ready and can read the named mount Secret; retained storage permits shared-key
network access. Node requests leave capacity for the frontend. Benthic's four
apps and hello HTTP baseline, and Traefik/cert-manager, were healthy before work.

Applied independently reviewed exact saved plans in order:
`Personal.Workload.AKS.NGINX-Hello.RG/resource_group` created one RG, then
`kubernetes` created exactly five objects with no updates, imports or deletions.
Both use new literal Azure keys in `personalcorestatefile/statefiles`, Entra/CLI
authentication and disabled automatic Azure resource-provider registration.
Scoped reflow and both provider-edited roots validated again before execution.
Protected plans, logs, baselines and backups are under ignored
`ignore/deployments/Personal.Workload.AKS.NGINX-Hello.RG/`. The workload's plan and
state contain the retained storage key and stay under restricted custody.

The new frontend is 1/1 Ready with zero restarts, the pinned image index/amd64
runtime digest verified and the readonly Blob CSI content mount working. One
ready endpoint backs its direct LoadBalancer at `130.107.41.55`. Its hostless
Traefik Ingress publishes `20.116.164.206`. Both HTTP routes returned 200 with
the same UTF8 body hash/length as old Benthic hello. The informational HTTPS
probe returned 404 with certificate validation skipped; trusted workload TLS
was not claimed.

Traefik's Deployment/Service identities, generations and public IP are unchanged;
all three cert-manager Deployments retain their identities/generations and are
Ready. Benthic remains Running with one Ready node, all twenty-four baseline
controllers and four apps healthy, the global context unchanged and its hello
HTTP response still 200 with identical content. The retained account remains in
its legacy RG: its ID, endpoint, ACL/key metadata, SKU/tags and container
ID/etag/access are unchanged. No storage move, adoption, blob write or DNS change
occurred. The storage-account sibling remains uninitialized.

Both final Terraform plans returned zero changes. RG state has one managed
instance at serial 2; Kubernetes state has five at serial 3. Each complete pulled
state equals its direct authenticated blob backup, has the exact reviewed managed
addresses, a released lease and stable ETag. The two new lineages differ from
each other and all four Core states. Plans/backups/credentials have ignored,
protected three-principal custody. Eleven of twenty-nine Personal roots are now
deployed (nine remote, two local); eighteen remote workload roots remain
uninitialized, including NGINX storage adoption and the seventeen other app roots.

**Work/validation:** Verify subscription/tenant, Personal endpoint/node group,
fresh state keys and object/RG names, retained account/container, existing hello
HTTP content and Benthic/platform health. Initialize/validate, independently review
and apply each saved plan in order: one RG creation, then five Kubernetes
creations with only expected data reads. Keep plans/state containing the storage
key private. Verify readonly Blob CSI content mounts, frontend readiness/image,
ready endpoints/public Service and Traefik HTTP content matching the old hello
baseline. Preserve shared controller identities/health, all Benthic controllers
and default context. Require final no-change plans, complete protected-state/
blob backup equality, independent lineages, released leases and restricted custody.

**Completion criteria:** Personal hello serves retained content through both
declared routes with its own verified state and Benthic still serving. No storage
move/adoption, blob upload, DNS cutover or other workload deployment occurs.

### [x] 2.0l Remove redundant input examples and review Stats readiness

**Completion notes:** The initial inventory found eleven `terraform.tfvars.example`
files: five Stats, three SFM and three Azurewebsiets. All eleven are removed;
three Stats files contained comments only, and eight templates merely duplicated
documented operational inputs. Root READMEs now name the applicable `TF_VAR_`
environment inputs without adding machine-specific values or replacement files.

All twelve variable declarations remain intentional: nine private kubeconfig
paths, two changing DNS traffic targets and Stats' staging/production ACME choice.
Its staging default, separate Issuer/account-key naming and production transition
are unchanged. Fixed subscription, location, RG/account, tag and image settings
were already literals; removing templates requires no Terraform behavior change.

Recursive Cloud Terrastodon reflow passed across the three affected workload
trees. All eleven example-owning roots validated with zero errors and warnings.
All 446 baseline hashes are identical after reflow: active Terraform, lockfiles,
initialized backend caches and both bootstrap local states. A full working-tree
search finds zero remaining templates, including ignored folders. Audit counts
and validation evidence are under `ignore/tfvars-cleanup/`. No init, plan, apply,
state operation or cloud call ran.

The Stats source audit confirms its five roots remain uninitialized. The next
candidate slice is `resource_group` -> `identity` -> `runtime`, retaining the
existing vault/token and old identity/grants. Before an authorized deployment,
bound Azure provider registration as for prior deployments, verify live target,
vault access/RBAC/network policy, GHCR digest, identity propagation and capacity,
then test `/healthz` and a real Stats response through private Service access.
The runtime is ClusterIP-only. Vault move/import/state handoff and certificate/
registrar DNS/public TLS remain separate gates. Corrected stale Stats README
naming and shared cert-manager deployment status; this review grants no deployment.

**Completion criteria:** Zero templates, documented genuine inputs, unchanged
Terraform/states and ACME policy, successful static validation, and a bounded
Stats deployment sequence without claiming live readiness or executing it.

### [x] 2.0m Reassess the migration after the pause

**Verified on 19 November 2026 (Toronto):**

- Azure reports both clusters as `Deallocated` with provisioning state
  `Failed`. Both node scale sets still have one instance, and both instances are
  deallocated. Neither Kubernetes API hostname resolved from this session, so
  workloads and add-on health could not be inspected. Both previously verified
  Personal hello HTTP routes and the public Stats health endpoint timed out.
  Azure still lists the two Personal public IPs as statically allocated and
  assigned. Recheck them after recovery.
- The user confirmed that hitting the billing limit paused the subscription.
  Azure now reports `Enabled`, with the spending limit still on and zero
  subscription-level budgets. Azure reports Resource Health as `Unknown` for
  both clusters. The available activity logs gave no cluster-specific recovery
  error. A managed start operation would establish whether each cluster can
  recover after reactivation.
- The Personal state account lists the same nine remote keys as October,
  including both hello states. Both independent local bootstrap state files are
  present. All 446 files in the October hash baseline match, including the
  Terraform source, locks, initialized backend caches and bootstrap states.
  This check compared state key names and local hashes.
- Azure confirms the Stats destination RG is absent. There are zero Stats
  state blobs, and all five Stats roots lack initialized backend metadata.
  The retained vault is still in the legacy RG with RBAC and purge protection
  enabled. Token usability from the replacement cluster remains untested.
- Azure reports zero VM scale set capacity for the original reference pool.
  Azure DevOps lists it as auto-provisioned with zero registered agents at the
  time of the check. Queue-triggered scale-up and access to existing state
  accounts still need a canary when reference work resumes.

The migration Terraform and docs remain in the local working tree. Include
approved source in the next Git checkpoint and keep credentials, plans and
state under their existing private custody. This reassessment used read-only
cloud queries and edited this plan. The October completion entries describe
what passed on those dates.

### [x] 2.0n Recover Personal cluster access and verify existing workloads

U47 confirms sufficient credit and authorizes Personal-AKS restoration.
The repository's budget-alert TODO remains relevant before running both side by side.
The normal start returned `OperationNotAllowed` in the deallocated/failed state.
Azure directed a retry via `az aks update`. It accepted the no-flags managed
reconciliation, and the power state became `Running` during provisioning.
Azure returned `Running/Succeeded` on Kubernetes 1.35.8. The verified API
reported one Ready node, working Blob CSI, established Traefik and cert-manager
CRDs and five Ready deployments. Both NGINX hello routes returned HTTP 200
with the October content hash on the same public addresses. Kubernetes reported
39% requested CPU and 10% requested memory, with headroom for Stats.
Terraform plans for the restored AKS, Traefik, cert-manager and hello runtime
each showed zero changes.
Use [AKS start](https://learn.microsoft.com/en-us/azure/aks/start-stop-cluster?tabs=azure-cli)
for the managed cluster. Capture the Azure operation result if startup fails and
diagnose its specific error before considering a repair or rebuild.

Recover Personal-AKS for the private Stats deployment. Recover Benthic as a
separate service-restoration decision because the public workloads and rollback
still depend on it. Benthic is on Kubernetes 1.29.10 and the Free tier. The
published 1.29 support window has ended. Azure's read-only upgrade profile lists
1.34.x for Benthic. Check the recovery and application compatibility of that
path before an upgrade. See [AKS version support](https://learn.microsoft.com/en-us/azure/aks/supported-kubernetes-versions)
and [restart diagnosis](https://learn.microsoft.com/en-us/troubleshoot/azure/azure-kubernetes/troubleshoot-aks-cluster-start-issues).

**Acceptance:** On Personal, verify API access, a Ready node, Traefik,
cert-manager, working Blob CSI mounts and both hello routes. Review AKS and
deployed add-on Terraform plans for drift with the existing backends after
access is restored. For any restored Benthic service, verify the four legacy
apps and their current endpoints before relying on it for rollback. Capture
any changes to endpoints, outbound address or API access rules.

### [x] 2.0o Deploy and verify the private Stats candidate

U47 authorizes the private deployment after Personal recovery. The Stats RG,
namespace and state keys were absent, and the existing vault was reachable
through Azure management with RBAC enabled. The pinned GHCR digest was available
for Linux/amd64. Azure provider auto-registration is disabled in the three
authorized roots. Recursive reflow and validation of those roots passed.
The reviewed saved plans applied in order:

1. `resource_group` creates the workload RG.
2. `identity` creates the Personal managed identity, AKS federation and Vault
   Secrets User grant against the retained vault.
3. `runtime` creates the namespace, ServiceAccount, Deployment and ClusterIP
   Service on Personal-AKS.

The three plans created one RG, three identity resources and four Kubernetes
objects. All three final plans showed zero changes. Each state has a distinct
lineage at serial 2 with a released lease. The full pulled backups match the
direct Entra blob reads. There are 14 deployed Personal roots, including the
two local bootstrap roots. Protected evidence is in
`ignore/deployments/Personal.Workload.AKS.GitHub-README-Stats.RG/`.

The original pod was Ready and the private Service returned HTTP 200 on
`/healthz`. Two fresh card requests returned HTTP 500. The application logs
showed successful Entra and Key Vault requests but omitted GitHub's status.

U48/U49 selected curl inside the Stats image and authorized the in-pod test.
The Dockerfile-only release branch published `sha-eb2c174`. Registry metadata
matched the release commit and the Linux/amd64 manifest. [Publication run](https://github.com/TeamDman/teamy-github-readme-stats/actions/runs/44668488572)

Terraform rolled out the verified digest
`sha256:08af49c524ec56f7fd98fd274101ef948477688f45e8392dc797cb21492d125a`
with one in-place Deployment image update and an image output update. Kubernetes
reported a Ready pod on the published image, and curl ran inside that pod.
The private health check returned HTTP 200. The final plan showed zero changes.
The runtime state advanced to serial 3 on its original lineage, with four
managed resources, a released lease and a protected backup matching the blob.

The read-only GraphQL diagnostic returned Entra HTTP 200, Key Vault HTTP 200,
then GitHub HTTP 401 with `Bad credentials`. The test used the existing pod
identity and vault token and captured only sanitized response metadata. GitHub
rejected the value retrieved from `github-token`. U50 confirms the replacement
is in 1Password and corrects the rotation path. The original
`teamy-github-readme-stats/platform/iac` backend still owns
`azurerm_key_vault_secret.github_token`. Its data source reads the 1Password
item, and AzureRM uses Set Secret for a changed value, adding a version in
the same vault. Review a saved plan targeted to the secret while Benthic is
deallocated. Apply only if the plan shows a secret value update and zero
other managed changes. Protect the saved plan and state because they contain
the token. Restart Stats after apply and confirm HTTP 200 with the expected
SVG for a fresh private card. The ownership recheck did not evaluate the
credential or run Terraform.

Under U51 the user confirmed that the targeted legacy Terraform apply had
updated the Key Vault secret. Personal-AKS then rolled over the original Stats
Deployment to a new Ready pod with zero restarts. The pod used the existing
workload identity without fallback credentials. The private Service returned
HTTP 200 on `/healthz` and on a fresh `refresh=true` request, which returned
the expected SVG card. Terraform removed the temporary restart annotation.
The replacement pod passed the same live checks, and the final runtime plan
showed zero changes. Private acceptance passed.

Public routing, HTTP01 staging and production issuance, and registrar DNS come
after private acceptance. HTTP01 needs the hostname to reach the intended
ingress. The vault move and import have their own ownership handoff. Reference
tasks 2.1 and 2.2 proceed independently, starting with agent canaries and
backend access before any state copy or queue switch. Azurewebsiets's zone move
keeps its own DNS and ownership checks. Verify data, certificates and rollback
for every migrated app before Benthic retirement.

### [ ] 2.1 Establish independent state ownership

**Work:** After Personal bootstrap 2.0, close the applicable G1 access and ownership
checks. Reference backend cutover additionally requires its G2 access/canary
prerequisites; these do not block Personal bootstrap. Preserve local bootstrap
state, inventory state/workspaces/marker data, freeze writers, copy and verify
whole-root backends, explicitly reconfigure backend authentication/caches and
readers, then resume canary consumers. Review separate split-state maps later.
Personal bootstrap 2.0 is complete. U33 retains its two local states and source
imports; their remote relocation is optional and is not the next required step.
New Personal networking/AKS roots can start with distinct fresh remote keys.
Do not copy Benthic cluster state into replacement AKS.

**Validation:** Secure backup/content verification and per-consumer state-access
checks, followed by separately authorized Terraform review.

**Completion criteria:** Exactly one writer per resource/state; rollback retained.

### [ ] 2.2 Separate reference networking and consumers

**Work:** Close G2; stage old/new subnet access and actual backend identity grants
before changing ACL-copy sources. Build a separate VMSS/pool with new-RG/subnet
roles, a verified supported management endpoint and pinned-image permissions.
Regenerate/review and provider-validate actual-value consumer copies before
promotion. Verify both projects' canaries, retain the old pool
through 2.1, switch queues and drain old jobs before removing bridge access.

**Validation:** Candidate jobs exercise required accounts under actual backend
identities, including disposable blob write/lease probes as well as reads. Confirm
queue/service-connection access, egress and old-pool rollback while still retained.

**Completion criteria:** Reference deployment runs on its own network and backend.

### [ ] 2.3 Replace AKS and migrate workloads

**Work:** Close G3 and the pre-replacement preservation portion of G7; define
current payloads, preserve content/secrets, review resource moves separately,
build replacement AKS, deploy add-ons/workloads and update OIDC/certificates.
Complete full G7 acceptance through 2.5 before switching traffic or retiring old
resources; retain rollback. G4 governs the planned later removal of CloudTerrastodon
test group, and AI uses G5 as an independent retirement decision.

**Validation:** Pre/post inventory, content checks, workload health, certificates,
DNS, public routes and identity access; approved state/infra plans before changes.

**Completion criteria:** Every migrate entry is reconciled without losing
workloads/data; ignored groups remain functioning; old AKS is retired only after
an explicit cutover decision and node-group lifecycle review.

### [ ] 2.4 Move the existing azurewebsiets.net zone

**Work:** Close G6 and follow the explicit zone procedure above. Preserve the zone,
record values, delegation and existing DNS identity during the RG move; reconcile
Terraform IDs, zone grants and issuer solver group settings before deployment or
DNS automation resumes. Keep identity replacement and ingress cutover separate.

**Validation:** Compare all records and assigned nameservers before/after, query
authoritative and recursive DNS, verify restored DNS permissions and a controlled
certificate challenge against the destination group. No live check ran now.

**Completion criteria:** The original zone is in `Personal.Workload.AKS.azurewebsiets.RG`,
DNS and certificates still work against the current traffic target, and exactly
one Terraform owner tracks its new zone/record IDs.

### [ ] 2.5 Prove data preservation and replacement workload restoration

**Work:** Close G7. Inventory/checksum all three live `webcontent` containers and
preserve or restore the complete content; include SFM's separate static upload.
Retain required secret material privately, bind replacement OIDC identities and
DNS permissions, select the intended available images and compatible platform
versions, and compare relevant live/source configuration beyond object names.

**Validation:** Compare content checksums and host-specific rendered pages, test
both hello routes, Stats API/Key Vault access, replacement image pulls and
controlled certificate issuance. Exercise encoded path/sanitization and
legitimate versus aliased request-header behavior against the actual NGINX
backends before traffic cutover; the 2.0f controller log raised the path advisory
while no applications were installed. Resolve unexplained live objects or configuration
differences before DNS traffic cutover. These tests are later authorized work.

**Completion criteria:** The replacement serves the intended content and APIs
with working TLS and identities; rollback remains usable. A matching application
list or successful `validate` alone does not satisfy this item.

### [ ] 2.6 Remove the CloudTerrastodon test vault without replacement

**Work:** Per U28, plan removal of `CACN-CloudTerrastodon-Test-RG` and its sole
observed resource, Key Vault `arbitraryname`. Refresh the nonsecret resource,
dependency and ownership inventory; establish whether any retained secret/data
custody is needed, and prepare the exact deletion scope for separate execution
authorization. Do not create a replacement group or vault. Keep AI retirement
under its independent G5 decision.

**Validation:** Later dependency/owner review and explicit deletion-scope review,
followed by a post-removal inventory only when execution is authorized.

**Completion criteria:** The approved test resources are removed with no new
deployment, required retained material has custody, and unrelated groups remain
untouched. No deletion is performed or authorized by this source phase.

## Risks and controls

| Risk | Control |
| --- | --- |
| Empty/new state causes duplicate resources or deletion plans | Preserve active backends; reserve new keys; require G1 and address mapping. |
| Agent loses network/state access | Optional explicit legacy subnet bridge; stage union ACLs across all accounts, audit Entra auth, verify independent candidate and drain old queues last. |
| AKS rename/move treated as supported | Separate replacement AKS source and fresh Kubernetes states; G3 replacement and workload cutover. |
| Content, DNS, keys or OIDC silently break | Explicit G6 zone move preserving NS/record values; reconcile IDs/RBAC/solver group, then independently cut over ingress/identity after checks. |
| Old rebuild instructions conflict with current intent | Current ledger governs; old notes are historical, no automatic teardown or AI redeploy. |
| IaC redeploy creates empty storage or changes a mutable image | G7/2.5 requires full content preservation, the intended available image, secret/identity access and a tested replacement before retirement. |

## Offline phase acceptance

- [x] Personal and reference scaffolds implement the named ownership boundaries.
- [x] Partition CIDRs and state keys are distinct; active legacy roots are preserved.
- [x] Validation evidence and its limits are recorded beside the completed tasks.
- [x] Every user requirement is covered by an implementation, explicit future gate
  or scoped non-goal; the three-pass audit is complete.
- [x] During offline Phase 1, no Terraform command except `validate`, cloud
  change, state migration, destruction, pipeline publication or deployment
  occurred. Later explicitly authorized Personal foundation deployments are
  recorded separately in Phase 2; they do not authorize migration/cutover.
