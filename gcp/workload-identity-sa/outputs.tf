output "gsa_email" {
  value = google_service_account.gsa.email
}

output "ksa_name" {
  value = kubernetes_service_account_v1.ksa.metadata[0].name
}
