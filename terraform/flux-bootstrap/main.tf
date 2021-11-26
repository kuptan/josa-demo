data "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-josa-demo"
  resource_group_name = "rg-josa-demo"
}

provider "helm" {
  kubernetes {
    host = data.azurerm_kubernetes_cluster.aks.kube_config.0.host

    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  }
}

provider "kubernetes" {
  host = data.azurerm_kubernetes_cluster.aks.kube_config.0.host

  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
}

provider "kubectl" {
  load_config_file = false
  host             = data.azurerm_kubernetes_cluster.aks.kube_config.0.host

  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
}

module "flux" {
  source = "kube-champ/flux-bootstrap/k8s"

  flux_auth_type    = "ssh"
  flux_ssh_scan_url = var.flux_ssh_scan_url
  git_url           = var.git_url
  git_branch        = "main"
  flux_target_path  = var.flux_target_path

  sealed_secrets_chart = {
    repository       = "https://bitnami-labs.github.io/sealed-secrets"
    chart_version    = "1.16.1"
    docker_image_tag = "v0.16.0"
  }
}