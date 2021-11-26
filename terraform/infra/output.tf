output "subnets" {
  value = {
    for s in azurerm_subnet.this :
    s.name => s.id
  }
}

output "kubeconfig" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.this.kube_config_raw
}

output "admin_kubeconfig" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.this.kube_admin_config_raw
}
