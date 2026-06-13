variable "namespace" {
  type    = string
  default = "traefik"
}

variable "chart_version" {
  type        = string
  description = "Traefik helm chart version."
  default     = "33.0.0"
}

variable "letsencrypt_email" {
  type        = string
  description = "Email for Let's Encrypt ACME registration."
}

variable "log_level" {
  type    = string
  default = "INFO"
}
