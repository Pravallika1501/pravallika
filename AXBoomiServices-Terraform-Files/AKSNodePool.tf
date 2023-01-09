resource "azurerm_kubernetes_cluster_node_pool" "AKS-BoomiNodePool" {
  enable_auto_scaling   = true
  kubernetes_cluster_id = azurerm_kubernetes_cluster.AKS-Boomi-Services.id
  max_count             = var.AKSSettings.MaxNodeCount
  min_count             = var.AKSSettings.MinNodeCount
  mode                  = "User"
  name                  = var.AKSSettings.DeploymentName
  #orchestrator_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  os_disk_size_gb       = var.AKSSettings.DiskSize
  os_type               = var.AKSSettings.OSPool # Default is Linux, we can change to Windows
  vm_size               = var.AKSSettings.NodeSize
  vnet_subnet_id        = azurerm_subnet.AKS-Subnet-BoomiServices.id
  priority              = "Regular"  # Default is Regular, we can change to Spot with additional settings like eviction_policy, spot_max_price, node_labels and node_taints
  depends_on            = [azurerm_role_assignment.BoomiServicesRole]
  #enable_host_encryption  = true
  node_labels = {
    "nodepool-type" = "User"
    "environment"   = "${terraform.workspace}"
    "nodepoolos"    = var.AKSSettings.OSPool
    "app"           = "boomi"
  }
  tags = {
    "nodepool-type" = "User"
    "environment"   = "${terraform.workspace}"
    "nodepoolos"    = var.AKSSettings.OSPool
    "app"           = "boomi"
  }
}
resource "azurerm_kubernetes_cluster_node_pool" "AKS-MonitoringPool" {
  enable_auto_scaling   = true
  kubernetes_cluster_id = azurerm_kubernetes_cluster.AKS-Boomi-Services.id
  max_count             = var.AKSSettings.MaxNodeCount
  min_count             = var.AKSSettings.MinNodeCount
  mode                  = "User"
  name                  = var.AKSSettings.MonitoringPoolName
  #orchestrator_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  os_disk_size_gb       = var.AKSSettings.DiskSize
  os_type               = var.AKSSettings.OSPool # Default is Linux
  vm_size               = var.AKSSettings.AdminSize
  vnet_subnet_id        = azurerm_subnet.AKS-Subnet-BoomiServices.id
  priority              = "Regular"  # Default is Regular, we can change to Spot with additional settings like eviction_policy, spot_max_price, node_labels and node_taints
  depends_on            = [azurerm_kubernetes_cluster_node_pool.AKS-BoomiNodePool]
  #enable_host_encryption  = true
  #only_critical_addons_enabled = true
  node_labels = {
    "nodepool-type" = "User"
    "environment"   = "${terraform.workspace}"
    "nodepoolos"    = var.AKSSettings.OSPool
    "app"           = "monitoringpool"
  }
  tags = {
    "nodepool-type" = "User"
    "environment"   = "${terraform.workspace}"
    "nodepoolos"    = var.AKSSettings.OSPool
    "app"           = "monitoringpool"
  }
}