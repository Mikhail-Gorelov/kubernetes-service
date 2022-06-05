resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"
  version    = var.helm_version
  namespace  = kubernetes_namespace.traefik.metadata[0].name

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

  depends_on = [kubernetes_namespace.traefik]
}

resource "kubernetes_namespace" "traefik" {
  metadata {
    name = var.namespace
  }
}