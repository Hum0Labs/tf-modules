variable "namespace" {
  type    = string
  default = "keel"
}

variable "chart_version" {
  type        = string
  description = "Keel helm chart version (null = latest)."
  default     = null
}

variable "values" {
  type        = any
  description = "Extra helm values (e.g. registry polling config)."
  default     = {}
}
