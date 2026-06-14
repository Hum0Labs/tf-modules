provider "kubernetes" {
  host = "https://localhost:6443"
}

run "keel_annotations_land_on_deployment_metadata" {
  command = plan

  variables {
    name           = "test"
    image          = "example/test:tag"
    container_port = 3000
    deployment_annotations = {
      "keel.sh/policy"  = "force"
      "keel.sh/trigger" = "poll"
    }
  }

  assert {
    condition     = kubernetes_deployment_v1.this.metadata[0].annotations["keel.sh/policy"] == "force"
    error_message = "keel.sh/policy must be set on the Deployment's own metadata annotations (where Keel reads it)"
  }

  assert {
    condition     = kubernetes_deployment_v1.this.metadata[0].annotations["keel.sh/trigger"] == "poll"
    error_message = "deployment_annotations must be applied to the Deployment metadata"
  }
}
