# Cloud SQL for PostgreSQL on a PRIVATE IP (no public access). Reachable from the
# GKE cluster over the shared VPC. The VPC's private-services-access connection must
# exist first (pass `depends_on = [module.vpc]` from the caller).

resource "google_sql_database_instance" "this" {
  project          = var.project_id
  name             = var.name
  region           = var.region
  database_version = var.database_version

  deletion_protection = var.deletion_protection

  settings {
    edition           = var.edition # ENTERPRISE allows db-custom-* tiers (Tier A); ENTERPRISE_PLUS forces db-perf-optimized-*
    tier              = var.tier
    availability_type = var.availability_type # ZONAL (Tier A) | REGIONAL (HA)
    disk_size         = var.disk_size
    disk_autoresize   = var.disk_autoresize

    ip_configuration {
      ipv4_enabled                                  = var.ipv4_enabled
      private_network                               = var.private_network
      enable_private_path_for_google_cloud_services = true
      ssl_mode                                      = var.ssl_mode

      # Public-IP allowlist. Only consulted when ipv4_enabled = true; empty list
      # means no IP may connect directly (the private path is unaffected).
      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.value
        }
      }
    }

    backup_configuration {
      enabled                        = var.backup_enabled
      start_time                     = var.backup_start_time
      point_in_time_recovery_enabled = var.point_in_time_recovery
    }
  }
}

resource "google_sql_database" "this" {
  for_each = toset(var.databases)
  project  = var.project_id
  name     = each.value
  instance = google_sql_database_instance.this.name
}

# One password per user. special=false keeps the value safe to drop into a
# postgresql:// URL without percent-encoding.
resource "random_password" "user" {
  for_each = toset(var.users)
  length   = 24
  special  = false
}

resource "google_sql_user" "this" {
  for_each = toset(var.users)
  project  = var.project_id
  name     = each.value
  instance = google_sql_database_instance.this.name
  password = random_password.user[each.value].result
}
