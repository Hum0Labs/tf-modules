variable "project_id" {
  type        = string
  description = "GCP project ID."
}

variable "authorized_domains" {
  type        = list(string)
  description = "Domains allowed for auth flows (e.g. localhost + your app domain)."
  default     = ["localhost"]
}
