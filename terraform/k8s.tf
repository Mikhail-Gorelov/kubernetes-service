provider "kubernetes" {
#  load_config_file = false

  host = yandex_kubernetes_cluster.kubernetes-services.master[0].external_v4_endpoint
  cluster_ca_certificate = yandex_kubernetes_cluster.kubernetes-services.master[0].cluster_ca_certificate
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command = "${var.YC_CLI_FOLDER}/yandex-cloud/bin/yc"
    args = [
      "managed-kubernetes",
      "create-token",
      "--cloud-id", var.CLOUD_ID,
      "--folder-id", var.FOLDER,
      "--token", var.TOKEN,
    ]
  }
}

provider "helm" {
  kubernetes {
#    load_config_file = false

    host = yandex_kubernetes_cluster.kubernetes-services.master[0].external_v4_endpoint
    cluster_ca_certificate = yandex_kubernetes_cluster.kubernetes-services.master[0].cluster_ca_certificate
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command = "${var.YC_CLI_FOLDER}/yandex-cloud/bin/yc"
      args = [
        "managed-kubernetes",
        "create-token",
        "--cloud-id", var.CLOUD_ID,
        "--folder-id", var.FOLDER,
        "--token", var.TOKEN,
      ]
    }
  }
}