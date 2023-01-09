resource "azapi_resource" "azgrafana" {
  type                     = "Microsoft.Dashboard/grafana@2022-08-01" 
  name                     = "Grafana-${local.ResourceSuffix}"
  parent_id                = azurerm_resource_group.RG-BoomiServices.id
  location                 = var.GrafanaSettings.location
  depends_on                       = [azurerm_private_endpoint.CR-PrivateEndpoint]
  identity {
    type      = "SystemAssigned"
  }

  body = jsonencode({
    sku = {
      name = "Standard"
    }
    properties = {
      publicNetworkAccess = "Disabled",
      zoneRedundancy = "Enabled",
      apiKey = "Enabled",
      deterministicOutboundIP = "Enabled"
    }
  })

}