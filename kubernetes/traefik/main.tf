# Traefik v3 via Helm, with an HTTP-01 Let's Encrypt cert resolver named
# "letsencrypt". IngressRoutes reference it via tls.certResolver = "letsencrypt".
# acme.json is persisted on a small PVC; an init container fixes its permissions.

resource "helm_release" "traefik" {
  name             = "traefik"
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://traefik.github.io/charts"
  chart            = "traefik"
  version          = var.chart_version

  values = [yamlencode({
    logs = {
      general = { level = var.log_level }
    }

    # Redirect all HTTP to HTTPS.
    ports = {
      web = {
        redirectTo = {
          port     = "websecure"
          priority = 10
        }
      }
    }

    # Persist acme.json across restarts.
    persistence = {
      enabled     = true
      name        = "data"
      accessMode  = "ReadWriteOnce"
      size        = "128Mi"
      path        = "/data"
    }

    deployment = {
      initContainers = [
        {
          name    = "volume-permissions"
          image   = "busybox:1.36"
          command = ["sh", "-c", "touch /data/acme.json && chmod 600 /data/acme.json"]
          volumeMounts = [
            { name = "data", mountPath = "/data" }
          ]
        }
      ]
    }

    # A single replica is required for the file-based ACME store.
    deploymentReplicas = 1

    additionalArguments = [
      "--certificatesresolvers.letsencrypt.acme.email=${var.letsencrypt_email}",
      "--certificatesresolvers.letsencrypt.acme.storage=/data/acme.json",
      "--certificatesresolvers.letsencrypt.acme.httpchallenge.entrypoint=web",
    ]
  })]
}
