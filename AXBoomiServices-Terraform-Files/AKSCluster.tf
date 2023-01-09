resource "azurerm_kubernetes_cluster" "AKS-Boomi-Services" {
  name                    = "AKS-${var.ProjectName}${local.ResourceSuffix}"
  kubernetes_version      = var.AKSSettings.Version
  location                = var.Location
  resource_group_name     = azurerm_resource_group.RG-BoomiServices.name
  private_cluster_enabled = true
  disk_encryption_set_id  = azurerm_disk_encryption_set.BoomiServices-Disk-Encryption-Key.id
  dns_prefix              = "aks${local.StorageSuffix}"
  depends_on              = [azapi_resource.azgrafana]
  azure_policy_enabled    = true
  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = true
  }

  default_node_pool {
    name                         = "admin"
    node_count                   = var.AKSSettings.NodeCount
    vm_size                      = var.AKSSettings.AdminSize
    type                         = "VirtualMachineScaleSets"
    enable_auto_scaling          = false
    vnet_subnet_id               = azurerm_subnet.AKS-Subnet-BoomiServices.id
    only_critical_addons_enabled = true
  }

  identity {
    type = "SystemAssigned"
  }



  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.Log-BoomiServices.id
  }
  network_profile {
    load_balancer_sku  = var.AKSSettings.LBSKU
    network_plugin     = var.AKSSettings.NetworkPluginType
    network_policy     = var.AKSSettings.NetworkPolicy
    service_cidr       = var.AKSSettings.CIDR
    dns_service_ip     = var.AKSSettings.DNSServiceIP
    docker_bridge_cidr = var.AKSSettings.DockerBridgeCIDR
  }
}
resource "azurerm_role_assignment" "BoomiServicesRole" {
  principal_id                     = azurerm_kubernetes_cluster.AKS-Boomi-Services.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.CR-BoomiServices.id
  skip_service_principal_aad_check = true
  depends_on                       = [azurerm_kubernetes_cluster.AKS-Boomi-Services]
}
