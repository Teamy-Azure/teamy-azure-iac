# Stats identity

Owns a new Personal identity, new-cluster federation and a scoped grant on the
existing vault. The RG is created by the `resource_group` sibling. New AKS OIDC
and retained vault metadata are looked up by literal names/RGs; its GitHub token
value is never retrieved. The vault lookup RG starts at the old RG; edit that
literal only after the approved move, then repair grant scopes.
Keep legacy identity/federation/grants until traffic and rollback are settled.
See the parent migration README for ownership and eventual vault move gates.
