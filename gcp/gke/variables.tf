variable "project_id" {
  type        = string
  description = "GCP project ID."
}

variable "name" {
  type        = string
  description = "Cluster name."
}

variable "location" {
  type        = string
  description = "Zone (e.g. us-east1-b) for a zonal cluster, or region for a regional (HA) cluster."
}

variable "network" {
  type        = string
  description = "VPC network ID/self_link."
}

variable "subnetwork" {
  type        = string
  description = "Subnetwork ID/self_link."
}

variable "pods_range_name" {
  type        = string
  description = "Secondary range name for pods."
}

variable "services_range_name" {
  type        = string
  description = "Secondary range name for services."
}

variable "node_machine_type" {
  type        = string
  description = "Node machine type."
  default     = "e2-standard-2"
}

variable "node_min" {
  type        = number
  description = "Min nodes (per zone)."
  default     = 1
}

variable "node_max" {
  type        = number
  description = "Max nodes (per zone)."
  default     = 2
}

variable "node_disk_gb" {
  type        = number
  description = "Node boot disk size (GB)."
  default     = 50
}

variable "node_labels" {
  type        = map(string)
  description = "Labels applied to nodes."
  default     = {}
}

variable "release_channel" {
  type        = string
  description = "GKE release channel: RAPID | REGULAR | STABLE."
  default     = "REGULAR"
}

variable "enable_private_nodes" {
  type        = bool
  description = "Private nodes (requires Cloud NAT for egress). Default false = public nodes."
  default     = false
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "Control-plane CIDR (only used when enable_private_nodes = true)."
  default     = "172.16.0.0/28"
}

variable "deletion_protection" {
  type        = bool
  description = "Block terraform destroy of the cluster. Keep false for dev iteration."
  default     = false
}
