resource "azurerm_managed_disk" "NFSServer-BoomiServices-DataDisk" {
  name                   = "Disk-NFS-${var.ProjectName}${local.ResourceSuffix}"
  location               = azurerm_resource_group.RG-BoomiServices.location
  resource_group_name    = azurerm_resource_group.RG-BoomiServices.name
  storage_account_type   = var.VirtualMachineSettings.StorageType
  create_option          = "Empty"
  disk_encryption_set_id = azurerm_disk_encryption_set.BoomiServices-Disk-Encryption-Key.id
  disk_size_gb           = var.VirtualMachineSettings.NFSDataDiskSize
  tags                   = local.CommonTags
  depends_on             = [azurerm_virtual_machine_extension.ADD-Extension-SSHLogin]
}
resource "azurerm_virtual_machine_data_disk_attachment" "NFSServer-DataDisk-Attache" {
  managed_disk_id    = azurerm_managed_disk.NFSServer-BoomiServices-DataDisk.id
  virtual_machine_id = azurerm_linux_virtual_machine.BoomiServices-NFSServer.id
  lun                = var.VirtualMachineSettings.DiskLUN
  caching            = var.VirtualMachineSettings.DiskCaching
  depends_on         = [azurerm_managed_disk.NFSServer-BoomiServices-DataDisk]
}
