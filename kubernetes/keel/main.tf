# Keel — polls the container registry and redeploys workloads carrying
# keel.sh/* annotations when a watched tag gets a new digest.
#
# Registry auth: GKE nodes can pull Artifact Registry images in the same project
# via the node SA, but Keel's *poll* queries the registry API and may need
# credentials for private repos — pass them through `values` if needed.

resource "helm_release" "keel" {
  name             = "keel"
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://charts.keel.sh"
  chart            = "keel"
  version          = var.chart_version

  values = [yamlencode(var.values)]
}
