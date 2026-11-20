terraform {
  # Create the group before its sibling storage root can create the backend.
  # Keep this local state separate and secure; imports support recovery without it.
  backend "local" {}
}
