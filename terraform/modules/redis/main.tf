resource "helm_release" "redis" {
  name       = "redis"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  version    = var.helm_version
  namespace  = kubernetes_namespace.redis.metadata[0].name

  values = [templatefile("${path.module}/config_files/${var.values_file}", {
    public_ip = var.public_ip_address
  })]

  set {
    name  = "image.tag"
    value = var.image_tag
  }

  set {
    name  = "deployment.replicas"
    value = var.replica_count
  }

  depends_on = [kubernetes_namespace.redis]
}

resource "kubernetes_namespace" "redis" {
  metadata {
    name = var.namespace
  }
}