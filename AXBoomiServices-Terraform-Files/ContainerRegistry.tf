resource "azurerm_user_assigned_identity" "Identity-CR-BoomiService" {
  name                = "Id-${var.ProjectName}${local.ResourceSuffix}"
  resource_group_name = azurerm_resource_group.RG-BoomiServices.name
  location            = azurerm_resource_group.RG-BoomiServices.location
  depends_on          = [azurerm_log_analytics_solution.LAS-BoomiServices]
  tags                = local.CommonTags
}

resource "azurerm_container_registry" "CR-BoomiServices" {
  name                = "cr${local.StorageSuffix}"
  resource_group_name = azurerm_resource_group.RG-BoomiServices.name
  location            = azurerm_resource_group.RG-BoomiServices.location
  sku                 = var.ACRSku
  admin_enabled       = true
  network_rule_set {
    default_action = "Allow"

  }
  depends_on = [azurerm_user_assigned_identity.Identity-CR-BoomiService]
  tags       = local.CommonTags
}

resource "azurerm_private_endpoint" "CR-PrivateEndpoint" {
  name                = "PEP-CR-${var.ProjectName}${local.ResourceSuffix}"
  location            = azurerm_resource_group.RG-BoomiServices.location
  resource_group_name = azurerm_resource_group.RG-BoomiServices.name
  subnet_id           = azurerm_subnet.AKS-Subnet-BoomiServices.id
  depends_on          = [azurerm_container_registry.CR-BoomiServices]

  private_service_connection {
    name                           = "PSC-CR-${var.ProjectName}${local.ResourceSuffix}"
    private_connection_resource_id = azurerm_container_registry.CR-BoomiServices.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }
}
