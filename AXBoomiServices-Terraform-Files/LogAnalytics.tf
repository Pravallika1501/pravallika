resource "azurerm_log_analytics_workspace" "Log-BoomiServices" {
  name                = "Log-${var.ProjectName}${local.ResourceSuffix}"
  location            = azurerm_resource_group.RG-BoomiServices.location
  resource_group_name = azurerm_resource_group.RG-BoomiServices.name
  sku                 = "PerGB2018"
  retention_in_days   = var.RetentionPeriod
  depends_on          = [azurerm_virtual_machine_data_disk_attachment.NFSServer-DataDisk-Attache]
  tags     = local.CommonTags
}

resource "azurerm_log_analytics_solution" "LAS-BoomiServices" {
    solution_name         = var.ContainerInsights
    location              = azurerm_resource_group.RG-BoomiServices.location
    resource_group_name   = azurerm_resource_group.RG-BoomiServices.name
    workspace_resource_id = azurerm_log_analytics_workspace.Log-BoomiServices.id
    workspace_name        = azurerm_log_analytics_workspace.Log-BoomiServices.name
    depends_on            = [azurerm_log_analytics_workspace.Log-BoomiServices]

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }

    tags     = local.CommonTags
}

