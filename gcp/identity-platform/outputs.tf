output "project_id" {
  value = var.project_id
}

output "api_key" {
  description = "API key for the Identity Toolkit sign-in REST endpoint (backend)."
  value       = google_apikeys_key.signin.key_string
  sensitive   = true
}
