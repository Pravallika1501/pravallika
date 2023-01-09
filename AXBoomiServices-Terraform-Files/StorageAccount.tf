# Create storage account for boot diagnostics
resource "azurerm_storage_account" "stboomiservices" {
  name                     = "st${local.StorageSuffix}"
  resource_group_name      = azurerm_resource_group.RG-BoomiServices.name
  location                 = azurerm_resource_group.RG-BoomiServices.location
  account_tier             = var.StorageAccountSettings.Accounttier
  account_replication_type = var.StorageAccountSettings.ReplicationType
  min_tls_version          = var.StorageAccountSettings.TLSVersion
  enable_https_traffic_only = var.StorageAccountSettings.write
  depends_on               = [azurerm_network_interface_security_group_association.NSG-Association]
  queue_properties  {
    logging {
        delete                = var.StorageAccountSettings.delete
        read                  = var.StorageAccountSettings.read
        write                 = var.StorageAccountSettings.write
        version               = var.StorageAccountSettings.version
        retention_policy_days = var.StorageAccountSettings.RetentionPolicy
    }
    hour_metrics {
        enabled               = var.StorageAccountSettings.enabled
        include_apis          = var.StorageAccountSettings.include_apis 
        version               = var.StorageAccountSettings.version
        retention_policy_days = var.StorageAccountSettings.days
    }
    minute_metrics {
        enabled               = var.StorageAccountSettings.enabled
        include_apis          = var.StorageAccountSettings.include_apis 
        version               = var.StorageAccountSettings.version
        retention_policy_days = var.StorageAccountSettings.days
    }
  }
  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [azurerm_subnet.NFS-Subnet-BoomiServices.id]
  }

  tags     = local.CommonTags
}