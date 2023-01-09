resource "azurerm_network_security_group" "NSG-BoomiServices" {
  name                = "NSG-NFS-${var.ProjectName}${local.ResourceSuffix}"
  location            = azurerm_resource_group.RG-BoomiServices.location
  resource_group_name = azurerm_resource_group.RG-BoomiServices.name
  depends_on          = [azurerm_resource_group.RG-BoomiServices]

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.CommonTags
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "VNet-${var.ProjectName}${local.ResourceSuffix}"
  location            = azurerm_resource_group.RG-BoomiServices.location
  resource_group_name = azurerm_resource_group.RG-BoomiServices.name
  address_space       = [var.VNetAddressSpace]
  depends_on          = [azurerm_network_security_group.NSG-BoomiServices]
  tags                = local.CommonTags
}

resource "azurerm_subnet" "AKS-Subnet-BoomiServices" {
  name                 = "SNet-AKS-${var.ProjectName}${local.ResourceSuffix}"
  resource_group_name  = azurerm_resource_group.RG-BoomiServices.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [local.SubNets[0]]
  depends_on           = [azurerm_virtual_network.virtual_network]
}

resource "azurerm_subnet" "AKS-Vnode-Subnet-BoomiServices" {
  name                 = "SNet-VNode-${var.ProjectName}${local.ResourceSuffix}"
  resource_group_name  = azurerm_resource_group.RG-BoomiServices.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [local.SubNets[1]]
  depends_on           = [azurerm_subnet.AKS-Subnet-BoomiServices]
}

resource "azurerm_subnet" "NFS-Subnet-BoomiServices" {
  name                 = "SNet-NFS-${var.ProjectName}${local.ResourceSuffix}"
  resource_group_name  = azurerm_resource_group.RG-BoomiServices.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [local.SubNets[2]]
  service_endpoints    = ["Microsoft.Storage"]
  depends_on           = [azurerm_subnet.AKS-Vnode-Subnet-BoomiServices]
}

resource "azurerm_subnet" "Azure-Firewall-Subnet-BoomiServices" {
  name                 = var.FirewallSettings.Name
  resource_group_name  = azurerm_resource_group.RG-BoomiServices.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [local.SubNets[3]]
  depends_on           = [azurerm_subnet.NFS-Subnet-BoomiServices]
}
