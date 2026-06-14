output "project_id" {
  value = var.project_id
}

output "api_key" {
  description = "API key for the Identity Toolkit sign-in REST endpoint (backend)."
  value       = google_apikeys_key.signin.key_string
  sensitive   = true
}

output "tenants" {
  description = "Map of tenant display name => server-generated tenant id (e.g. { production = \"production-ab12c\" })."
  value       = { for name, t in google_identity_platform_tenant.tenant : name => t.name }
}
