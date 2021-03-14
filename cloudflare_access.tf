resource "cloudflare_access_policy" "access_policy_emails_my_service" {
  application_id = cloudflare_access_application.access_application_my_service.id
  zone_id        = var.cloudflare_zone_id
  name           = "Jose"
  precedence     = "1"
  decision       = "allow"

  include {
    email = [
      "jose@example.com",
    ]
  }
}

resource "cloudflare_access_application" "access_application_my_service" {
  zone_id                   = var.cloudflare_zone_id
  name                      = "My Service"
  domain                    = var.my_service_hostname
  session_duration          = "24h"
  auto_redirect_to_identity = true
}
