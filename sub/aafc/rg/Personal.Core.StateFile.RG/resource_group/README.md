# Personal state resource group

This root creates only `Personal.Core.StateFile.RG`. Its sibling `storage_account` root looks up this existing group to create the state account and private container. The group has `prevent_destroy` protection.

The managed address is `azurerm_resource_group.main`. The only output is
`resource_group`, containing the complete resource object rather than separate
ID and name outputs.

The bootstrap order is:

1. Deploy this `resource_group` root. Location `canadacentral`, subscription ID and tags are literals; there are no variable inputs.
2. Deploy the sibling `storage_account` root, which also has no variable inputs.

Both bootstrap roots were deployed on 16 October 2026. The group contains
`personalcorestatefile`, a StorageV2 account using Standard_LRS in `canadacentral`. The account's private
`statefiles` container has a container-scoped operator Storage Blob Data
Contributor grant. Entra-authenticated upload/download and finite blob lease
acquisition/release were verified on that date; the temporary probe was removed.

Both independent local states have secured, hash-verified backups under the
ignored custody directory. Acceptance evidence is held in
`ignore/bootstrap/Personal.Core.StateFile.RG/verification/bootstrap-acceptance.json`.
Final post-apply Terraform plans on that date returned no changes.

Both roots keep separate local backends. Relocation is not required or proposed.
The actual state paths, relative to the repository, are:

- `ignore/bootstrap/Personal.Core.StateFile.RG/resource_group.tfstate`
- `ignore/bootstrap/Personal.Core.StateFile.RG/storage_account.tfstate`

The custody directory has restricted NTFS permissions and holds saved plans,
execution logs and state backups. Preserve both states securely. Do not share
a state path between the roots or copy an existing combined state into either.

An active import block beside `azurerm_resource_group.main` records the deployed
RG's fixed ARM ID. Follow the mode that matches Azure and state ownership:

| Mode | Action |
| --- | --- |
| Authoritative state exists | Keep the import active and use that state. |
| Azure group exists but authoritative state is lost | Review and apply the RG import before recovering the storage sibling. Imports recover bindings, not state history. |
| Genuinely fresh Azure deployment | Comment out this import and all 3 storage-sibling imports, retaining the resources. Confirm Azure objects are absent and fixed names available before reviewing creation. |

The storage sibling fixes the grant's principal ID, while the role resource name
remains computed under the reflow convention. Its import records the exact
deployed assignment ID. A fresh deployment generates a new assignment GUID;
refresh that import ID before retaining or re-enabling recovery imports.

Keep one active state owner per root and preserve backups. Do not comment out
imports to treat existing Azure objects as a fresh deployment. The adjacent
[terraform.backend.tf](terraform.backend.tf) retains this root's local backend.

Recovery has not been tested live. The current task permits source reflow and
validation only; no import, plan, apply, state or backend operation is authorized.
