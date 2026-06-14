variable "name" {
  type        = string
  description = "Workload name (used for Deployment, Service, labels)."
}

variable "namespace" {
  type        = string
  description = "Namespace."
  default     = "default"
}

variable "image" {
  type        = string
  description = "Container image (with tag)."
}

variable "image_pull_policy" {
  type        = string
  description = "imagePullPolicy."
  default     = "Always"
}

variable "replicas" {
  type        = number
  description = "Replica count."
  default     = 1
}

variable "container_port" {
  type        = number
  description = "Port the container listens on."
}

variable "service_account_name" {
  type        = string
  description = "Kubernetes service account (for Workload Identity). Empty = default."
  default     = ""
}

variable "container_env" {
  type        = map(string)
  description = "Plain environment variables."
  default     = {}
}

variable "secret_env" {
  type        = map(string)
  description = "Sensitive env vars (stored in a Secret, mounted via envFrom)."
  default     = {}
  sensitive   = true
}

variable "init_containers" {
  type = list(object({
    name    = string
    image   = optional(string)
    command = optional(list(string))
    args    = optional(list(string))
  }))
  description = "Init containers (e.g. DB migrate). Inherit the workload's env."
  default     = []
}

variable "annotations" {
  type        = map(string)
  description = "Pod template annotations."
  default     = {}
}

variable "deployment_annotations" {
  type        = map(string)
  description = "Annotations on the Deployment's own metadata. Keel reads keel.sh/* policy here, not on the pod template."
  default     = {}
}

variable "limits_mem" {
  type        = string
  description = "Memory limit."
  default     = "512Mi"
}
