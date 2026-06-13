# A Deployment + ClusterIP Service, with optional secret env and init containers.
# Cloud-agnostic (pure kubernetes provider) — works on any cluster.

locals {
  labels      = { app = var.name }
  has_secrets = length(var.secret_env) > 0
}

resource "kubernetes_secret_v1" "env" {
  count = local.has_secrets ? 1 : 0
  metadata {
    name      = "${var.name}-env"
    namespace = var.namespace
  }
  data = var.secret_env
}

resource "kubernetes_deployment_v1" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        labels      = local.labels
        annotations = var.annotations
      }

      spec {
        service_account_name = var.service_account_name != "" ? var.service_account_name : null

        dynamic "init_container" {
          for_each = var.init_containers
          content {
            name    = init_container.value.name
            image   = coalesce(init_container.value.image, var.image)
            command = init_container.value.command
            args    = init_container.value.args

            dynamic "env" {
              for_each = var.container_env
              content {
                name  = env.key
                value = env.value
              }
            }

            dynamic "env_from" {
              for_each = local.has_secrets ? [1] : []
              content {
                secret_ref {
                  name = kubernetes_secret_v1.env[0].metadata[0].name
                }
              }
            }
          }
        }

        container {
          name              = var.name
          image             = var.image
          image_pull_policy = var.image_pull_policy

          port {
            container_port = var.container_port
          }

          dynamic "env" {
            for_each = var.container_env
            content {
              name  = env.key
              value = env.value
            }
          }

          dynamic "env_from" {
            for_each = local.has_secrets ? [1] : []
            content {
              secret_ref {
                name = kubernetes_secret_v1.env[0].metadata[0].name
              }
            }
          }

          resources {
            limits = {
              memory = var.limits_mem
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels
  }

  spec {
    selector = local.labels
    port {
      port        = 80
      target_port = var.container_port
    }
  }
}
