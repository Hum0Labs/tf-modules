variable "project_id" {
  type        = string
  description = "GCP project ID."
}

variable "region" {
  type        = string
  description = "Region for the subnet."
}

variable "name" {
  type        = string
  description = "Base name for the network and derived resources."
}

variable "subnet_cidr" {
  type        = string
  description = "Primary CIDR for the node subnet."
  default     = "10.10.0.0/20"
}

variable "pods_cidr" {
  type        = string
  description = "Secondary range for GKE pods."
  default     = "10.20.0.0/16"
}

variable "services_cidr" {
  type        = string
  description = "Secondary range for GKE services."
  default     = "10.30.0.0/20"
}
