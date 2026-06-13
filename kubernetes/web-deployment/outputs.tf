output "service_name" {
  value = kubernetes_service_v1.this.metadata[0].name
}

output "name" {
  value = var.name
}
