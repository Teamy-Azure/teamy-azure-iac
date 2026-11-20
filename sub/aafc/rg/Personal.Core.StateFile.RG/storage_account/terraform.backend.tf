terraform {
  # This root owns the account that will hold the other roots' state.
  # Preserve its local state separately from the resource_group sibling's state.
  # Imports recover the existing resources without a remote-backend dependency.
  backend "local" {}
}
