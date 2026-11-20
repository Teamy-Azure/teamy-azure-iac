variable "traffic_ipv4_address" {
  type = string
  description = "Current approved ingress IPv4; retain the old target through the resource and state moves."
  validation {
    condition = can(cidrhost(format("%s/32", var.traffic_ipv4_address), 0)) && !strcontains(var.traffic_ipv4_address, ":")
    error_message = "Provide the currently approved public ingress IPv4 address."
  }
}
