variable "project_id" {
  type        = string
  description = "GCP project ID."
}

variable "authorized_domains" {
  type        = list(string)
  description = "Domains allowed for auth flows (e.g. localhost + your app domain)."
  default     = ["localhost"]
}

variable "tenants" {
  type        = list(string)
  description = "Display names of Identity Platform tenants (isolated user pools) to create, e.g. [\"production\", \"staging\"]. Empty = no tenants (default pool only)."
  default     = []
}
