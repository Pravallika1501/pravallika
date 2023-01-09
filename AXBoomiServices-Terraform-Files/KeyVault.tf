resource "azurerm_key_vault" "KeyVault-BoomiServices" {
  name                = "KV-${var.ProjectNameShortCut}${local.ResourceSuffix}"
  location            = azurerm_resource_group.RG-BoomiServices.location
  resource_group_name = azurerm_resource_group.RG-BoomiServices.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  #soft_delete_enabled               = var.KeyVaultSettings.SetTrue
  soft_delete_retention_days      = 30
  enabled_for_disk_encryption     = var.KeyVaultSettings.SetTrue
  enabled_for_deployment          = var.KeyVaultSettings.SetTrue
  enabled_for_template_deployment = var.KeyVaultSettings.SetTrue
  sku_name                        = var.KeyVaultSettings.SKU
  purge_protection_enabled        = var.KeyVaultSettings.SetTrue
  network_acls {
    bypass         = "AzureServices"
    default_action = "Allow"
  }
  depends_on = [azurerm_subnet.Azure-Firewall-Subnet-BoomiServices]

  tags = local.CommonTags
}
resource "azurerm_key_vault_access_policy" "KV-Access-Policy" {
  key_vault_id       = azurerm_key_vault.KeyVault-BoomiServices.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azuread_service_principal.BuildAgent.id
  key_permissions    = ["Get", "Create", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify"]
  secret_permissions = ["Get"]
  depends_on         = [azurerm_key_vault.KeyVault-BoomiServices]
}
resource "azurerm_key_vault_key" "BoomiServices-NFSKey" {
  name         = "MK-NFS-${var.ProjectName}${local.ResourceSuffix}"
  key_vault_id = azurerm_key_vault.KeyVault-BoomiServices.id
  key_type     = "RSA-HSM"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
  depends_on   = [azurerm_key_vault_access_policy.KV-Access-Policy]
  tags         = local.CommonTags
}
####Key Vault Key For Disk Enecryption#####
resource "azurerm_key_vault_key" "DiskEncryption" {
  name         = "MK-DiskEncryption-${var.ProjectName}${local.ResourceSuffix}"
  key_vault_id = azurerm_key_vault.KeyVault-BoomiServices.id
  key_type     = "RSA-HSM"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
  depends_on   = [azurerm_key_vault_key.BoomiServices-NFSKey]
  tags         = local.CommonTags
}

####Disk Encryption Key ###########
resource "azurerm_disk_encryption_set" "BoomiServices-Disk-Encryption-Key" {
  name                = "DES-${var.ProjectName}${local.ResourceSuffix}"
  resource_group_name = azurerm_resource_group.RG-BoomiServices.name
  location            = azurerm_resource_group.RG-BoomiServices.location
  key_vault_key_id    = azurerm_key_vault_key.DiskEncryption.id
  identity {
    type = "SystemAssigned"
  }
  depends_on = [azurerm_key_vault_key.DiskEncryption]
}
resource "azurerm_key_vault_access_policy" "KV-Access-Policy-CMK" {
  key_vault_id = azurerm_key_vault.KeyVault-BoomiServices.id
  tenant_id    = azurerm_disk_encryption_set.BoomiServices-Disk-Encryption-Key.identity.0.tenant_id
  object_id    = azurerm_disk_encryption_set.BoomiServices-Disk-Encryption-Key.identity.0.principal_id
  depends_on   = [azurerm_disk_encryption_set.BoomiServices-Disk-Encryption-Key]
  key_permissions = [
    "Decrypt",
    "Encrypt",
    "Sign",
    "UnwrapKey",
    "Verify",
    "WrapKey",
    "Get",
    "List",
    "Update",
  ]
}

