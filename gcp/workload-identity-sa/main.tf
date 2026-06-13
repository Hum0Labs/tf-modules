# Creates a Google service account, grants it project roles, binds it to a
# Kubernetes service account via Workload Identity, and creates that KSA with
# the linking annotation so pods using it act as the GSA.

resource "google_service_account" "gsa" {
  project      = var.project_id
  account_id   = var.gsa_name
  display_name = "WI: ${var.gsa_name}"
}

resource "google_project_iam_member" "roles" {
  for_each = toset(var.project_roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.gsa.email}"
}

# Sign GCS URLs without a key (IAM signBlob) — GSA impersonates itself.
resource "google_service_account_iam_member" "self_token_creator" {
  count              = var.self_token_creator ? 1 : 0
  service_account_id = google_service_account.gsa.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${google_service_account.gsa.email}"
}

# Allow the KSA to impersonate the GSA.
resource "google_service_account_iam_member" "workload_identity" {
  service_account_id = google_service_account.gsa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${var.namespace}/${var.ksa_name}]"
}

resource "kubernetes_service_account_v1" "ksa" {
  metadata {
    name      = var.ksa_name
    namespace = var.namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.gsa.email
    }
  }
}
