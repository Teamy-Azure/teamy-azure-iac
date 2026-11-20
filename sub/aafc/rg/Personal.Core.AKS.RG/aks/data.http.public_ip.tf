# Discover the current manual deployment operator without committing a public IP.
# terraform validate does not perform this request.
data "http" "public_ip" {
  url = "https://ipv4.icanhazip.com"
  lifecycle {
    postcondition {
      condition = can(cidrnetmask("${trimspace(self.response_body)}/32"))
      error_message = "The operator IP service must return a single valid IPv4 address."
    }
  }
}
