resource "azurerm_route_table" "BoomiServices-RouteTable" {
  name                          = "RT-${var.ProjectName}${local.ResourceSuffix}"
  location                      = azurerm_resource_group.RG-BoomiServices.location
  resource_group_name           = azurerm_resource_group.RG-BoomiServices.name
  disable_bgp_route_propagation = false
  depends_on                    = [azurerm_firewall.Firewall-BoomiServices]

  route {
    name                   = "RT-Firewall${var.ProjectName}${local.ResourceSuffix}"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.91.78.4" //TODO: Change to variable
  }

  tags = local.CommonTags
}

resource "azurerm_subnet_route_table_association" "BoomiServices-RouteTable-AKSSub-Association" {
  subnet_id      = azurerm_subnet.AKS-Subnet-BoomiServices.id
  route_table_id = azurerm_route_table.BoomiServices-RouteTable.id
  depends_on     = [azurerm_route_table.BoomiServices-RouteTable]
}

resource "azurerm_subnet_route_table_association" "BoomiServices-RouteTable-NFSSub-Subnet" {
  subnet_id      = azurerm_subnet.NFS-Subnet-BoomiServices.id
  route_table_id = azurerm_route_table.BoomiServices-RouteTable.id
  depends_on     = [azurerm_subnet_route_table_association.BoomiServices-RouteTable-AKSSub-Association]
}
