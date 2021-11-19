resource "azurerm_kubernetes_cluster" "this" {
  name                = "aks-${var.name}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = var.name

  default_node_pool {
    name           = "default"
    node_count     = var.k8s_default_node_count
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.this["snet1"].id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "calico"
    service_cidr       = "10.0.192.0/18"
    docker_bridge_cidr = "172.17.0.1/16"
    dns_service_ip     = "10.0.192.100"
  }

  tags = var.tags
}