# Retained Stats Key Vault adoption

This root adopts `teamygithubreadmestats` only after its separately authorized
resource-group move into `Personal.Workload.AKS.GitHub-README-Stats.RG`. The import
ID is the literal destination ID of the existing named vault. Verify the actual
moved ID before planning. Its import block fails if the retained vault does not exist at that ID; no replacement
vault or placeholder token is intended. `prevent_destroy` protects the vault.

Preserve RBAC, public-network access, purge protection, retention and every
secret version. The legacy runtime identity is looked up by the literal name
`teamy-github-readme-stats` in `TEAMY-GitHub-README-Stats-RG`; this root recreates
its vault-scoped Secrets User grant at the moved resource ID. The replacement
identity's grant belongs to `identity/`, whose lookup RG changes after the move. Preserve
existing administrator/publisher grants through their authoritative owners too;
this reader grant does not replace the complete live RBAC inventory. Reconcile
old state ownership before managing an existing identical grant in this root,
and prove both clusters retain token access. The legacy Terraform root owns
`github-token` and its rotation during overlap. This root adopts the vault;
the secret needs a separately reviewed Terraform owner and state handoff
before the move. Preserve the existing secret and all versions through that
handoff. See the [parent README](../README.md) for the current rotation path.

The RG sibling must exist first. Azure move validation, writer freeze, state
backup and ID/address handoff are Phase 2 prerequisites. No move, import, state
change or deployment is authorized by source validation.
