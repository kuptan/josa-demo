resource "azurerm_virtual_network" "this" {
  name                = "vnet-${var.name}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.vnet_address_space]

  tags = var.tags
}

resource "azurerm_subnet" "this" {
  for_each             = { for s in var.subnets : s.name => s }
  name                 = each.key
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.cidr]
}

resource "azurerm_dns_zone" "this" {
  name                = var.public_dns_zone_name
  resource_group_name = azurerm_resource_group.this.name
}