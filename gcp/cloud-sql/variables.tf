variable "project_id" {
  type        = string
  description = "GCP project ID."
}

variable "region" {
  type        = string
  description = "Region for the instance."
}

variable "name" {
  type        = string
  description = "Instance name."
}

variable "private_network" {
  type        = string
  description = "VPC network ID for the private IP. Requires private-services-access on that VPC."
}

variable "database_version" {
  type        = string
  description = "Postgres version."
  default     = "POSTGRES_16"
}

variable "edition" {
  type        = string
  description = "ENTERPRISE (allows cheap db-custom-* tiers) or ENTERPRISE_PLUS (db-perf-optimized-* only)."
  default     = "ENTERPRISE"
}

variable "tier" {
  type        = string
  description = "Machine tier (e.g. db-custom-1-3840). Must be a db-custom-* tier when edition = ENTERPRISE."
  default     = "db-custom-1-3840"
}

variable "availability_type" {
  type        = string
  description = "ZONAL (cheap, Tier A) or REGIONAL (HA)."
  default     = "ZONAL"
}

variable "disk_size" {
  type        = number
  description = "Data disk size (GB). Min 10."
  default     = 10
}

variable "disk_autoresize" {
  type        = bool
  description = "Grow disk automatically when full."
  default     = true
}

variable "databases" {
  type        = set(string)
  description = "Databases to create."
  default     = ["bodega"]
}

variable "users" {
  type        = set(string)
  description = "Users to create (each gets a random password)."
  default     = ["bodega"]
}

variable "backup_enabled" {
  type        = bool
  description = "Daily automated backups."
  default     = true
}

variable "backup_start_time" {
  type        = string
  description = "Backup window start (HH:MM, UTC)."
  default     = "07:00"
}

variable "point_in_time_recovery" {
  type        = bool
  description = "Enable PITR (WAL archiving; extra storage cost). Off by default for Tier A."
  default     = false
}

variable "deletion_protection" {
  type        = bool
  description = "Block terraform destroy of the instance. Keep false for dev iteration."
  default     = false
}
