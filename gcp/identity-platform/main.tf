# Identity Platform (GCP-managed auth) with email/password sign-in, plus an API
# key the backend uses to call the Identity Toolkit sign-in REST endpoint.
#
# Requires identitytoolkit.googleapis.com and apikeys.googleapis.com enabled.

resource "google_identity_platform_config" "default" {
  project = var.project_id

  sign_in {
    allow_duplicate_emails = false

    email {
      enabled           = true
      password_required = true
    }
  }

  multi_tenant {
    allow_tenants = true
  }

  authorized_domains = var.authorized_domains
}

resource "google_identity_platform_tenant" "tenant" {
  for_each = toset(var.tenants)

  project               = var.project_id
  display_name          = each.value
  allow_password_signup = true

  depends_on = [google_identity_platform_config.default]
}

resource "google_apikeys_key" "signin" {
  project      = var.project_id
  name         = "identity-platform-signin"
  display_name = "Identity Platform sign-in (backend)"

  restrictions {
    api_targets {
      service = "identitytoolkit.googleapis.com"
    }
  }

  depends_on = [google_identity_platform_config.default]
}
