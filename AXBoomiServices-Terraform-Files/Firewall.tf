# Create public IPs
resource "azurerm_public_ip" "PIP-Azure-Firewall" {
  name                = "PIP-AFW-${var.ProjectName}${local.ResourceSuffix}"
  location            = azurerm_resource_group.RG-BoomiServices.location
  resource_group_name = azurerm_resource_group.RG-BoomiServices.name
  allocation_method   = var.FirewallSettings.Allocation
  sku                 = var.FirewallSettings.SKUTier
  depends_on          = [azurerm_kubernetes_cluster_node_pool.AKS-MonitoringPool]

  tags = local.CommonTags
}

#Firewall Policy
resource "azurerm_firewall_policy" "Azure-Firewall-Policy" {
  name                = "AFWP-${var.ProjectName}${local.ResourceSuffix}"
  resource_group_name = azurerm_resource_group.RG-BoomiServices.name
  location            = azurerm_resource_group.RG-BoomiServices.location
  depends_on          = [azurerm_public_ip.PIP-Azure-Firewall]
}

resource "azurerm_firewall" "Firewall-BoomiServices" {
  name                = "AFW-${var.ProjectName}${local.ResourceSuffix}"
  location            = azurerm_resource_group.RG-BoomiServices.location
  resource_group_name = azurerm_resource_group.RG-BoomiServices.name
  sku_tier            = var.FirewallSettings.SKUTier
  sku_name            = "AZFW_VNet"
  firewall_policy_id  = azurerm_firewall_policy.Azure-Firewall-Policy.id
  depends_on          = [azurerm_firewall_policy.Azure-Firewall-Policy]

  ip_configuration {
    name                 = "PIP-AFW${local.ResourceSuffix}"
    subnet_id            = azurerm_subnet.Azure-Firewall-Subnet-BoomiServices.id
    public_ip_address_id = azurerm_public_ip.PIP-Azure-Firewall.id

  }

  tags = local.CommonTags
}
