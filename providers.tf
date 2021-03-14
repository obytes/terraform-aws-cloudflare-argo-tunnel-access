# It's required to define this provider explicitly as it's not on the hashicorp/* namespace.
terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}
