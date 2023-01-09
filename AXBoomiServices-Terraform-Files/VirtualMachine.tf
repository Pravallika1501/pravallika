resource "azurerm_availability_set" "NFSServer-Boomi-AVSet" {
  name                         = "Avail-${var.ProjectName}${local.ResourceSuffix}"
  location                     = azurerm_resource_group.RG-BoomiServices.location
  resource_group_name          = azurerm_resource_group.RG-BoomiServices.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
  tags                         = local.CommonTags
  depends_on                   = [azurerm_storage_account.stboomiservices]
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "BoomiServices-NFSServer" {
  name                            = "VM-NFS-${var.ProjectName}${local.ResourceSuffix}"
  location                        = azurerm_resource_group.RG-BoomiServices.location
  resource_group_name             = azurerm_resource_group.RG-BoomiServices.name
  availability_set_id             = azurerm_availability_set.NFSServer-Boomi-AVSet.id
  network_interface_ids           = [azurerm_network_interface.NFSServer-PrivateIP-BoomiService.id]
  size                            = var.VirtualMachineSettings.NFSVMSize
  disable_password_authentication = true
  allow_extension_operations      = true
  admin_username                  = var.VirtualMachineSettings.UserName
  provision_vm_agent              = true
  depends_on                      = [azurerm_availability_set.NFSServer-Boomi-AVSet]

  admin_ssh_key {
    username   = var.VirtualMachineSettings.UserName
    public_key = tls_private_key.BoomiNFSKey.public_key_openssh
  }

  os_disk {
    name                 = "OSDisk-NFS${local.ResourceSuffix}"
    caching              = var.VirtualMachineSettings.DiskCaching
    storage_account_type = var.VirtualMachineSettings.StorageType
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.stboomiservices.primary_blob_endpoint
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.CommonTags
}

resource "azurerm_virtual_machine_extension" "ADD-Extension-SSHLogin" {
  name                 = "azureadextension"
  virtual_machine_id   = azurerm_linux_virtual_machine.BoomiServices-NFSServer.id
  publisher            = "Microsoft.Azure.ActiveDirectory"
  type                 = "AADSSHLoginForLinux"
  type_handler_version = "1.0"
  depends_on           = [azurerm_linux_virtual_machine.BoomiServices-NFSServer]
  tags                 = local.CommonTags
}

