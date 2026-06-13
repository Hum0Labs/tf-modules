# GKE Standard cluster + a single managed node pool.
# location = a ZONE (e.g. us-east1-b) -> zonal cluster, exact node count (cheap, Tier A).
# location = a REGION (e.g. us-east1)  -> regional cluster, node count PER zone (HA, ~3x cost).

resource "google_container_cluster" "this" {
  project  = var.project_id
  name     = var.name
  location = var.location

  network         = var.network
  subnetwork      = var.subnetwork
  networking_mode = "VPC_NATIVE"

  # We manage our own node pool below.
  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_range_name
    services_secondary_range_name = var.services_range_name
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  release_channel {
    channel = var.release_channel
  }

  # Public nodes by default (no Cloud NAT needed). Flip on for private nodes (needs Cloud NAT).
  dynamic "private_cluster_config" {
    for_each = var.enable_private_nodes ? [1] : []
    content {
      enable_private_nodes    = true
      enable_private_endpoint = false
      master_ipv4_cidr_block  = var.master_ipv4_cidr_block
    }
  }

  deletion_protection = var.deletion_protection
}

resource "google_container_node_pool" "this" {
  project  = var.project_id
  name     = "${var.name}-pool"
  location = var.location
  cluster  = google_container_cluster.this.name

  autoscaling {
    min_node_count = var.node_min
    max_node_count = var.node_max
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type = var.node_machine_type
    disk_size_gb = var.node_disk_gb
    disk_type    = "pd-balanced"

    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

    # Enable Workload Identity on the nodes so pods can impersonate GSAs.
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = var.node_labels
  }
}
