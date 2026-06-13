variable "project_id" {
  type = string
}

variable "gsa_name" {
  type        = string
  description = "Google service account id (account_id)."
}

variable "ksa_name" {
  type        = string
  description = "Kubernetes service account name to create + bind."
}

variable "namespace" {
  type    = string
  default = "default"
}

variable "project_roles" {
  type        = list(string)
  description = "Project IAM roles to grant the GSA."
  default     = []
}

variable "self_token_creator" {
  type        = bool
  description = "Grant the GSA tokenCreator on itself (needed to sign GCS URLs without a key)."
  default     = false
}
