# Create network interface
resource "azurerm_network_interface" "NFSServer-PrivateIP-BoomiService" {
  name                          = "NIC-NFS-${var.ProjectName}${local.ResourceSuffix}-nic"
  location                      = azurerm_resource_group.RG-BoomiServices.location
  resource_group_name           = azurerm_resource_group.RG-BoomiServices.name
  enable_accelerated_networking = "true"
  depends_on                    = [azurerm_key_vault_access_policy.KV-Access-Policy-CMK]

  ip_configuration {
    name                          = "PIP${local.ResourceSuffix}"
    subnet_id                     = azurerm_subnet.NFS-Subnet-BoomiServices.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.CommonTags
}

resource "tls_private_key" "BoomiNFSKey" {
  algorithm  = "RSA"
  rsa_bits   = 4096
  depends_on = [azurerm_network_interface.NFSServer-PrivateIP-BoomiService]
}

# Create (and display) an SSH key
resource "azurerm_ssh_public_key" "Boomi-NFS-SSH-Key" {
  name                = "SSH-Key-${var.ProjectName}${local.ResourceSuffix}"
  resource_group_name = azurerm_resource_group.RG-BoomiServices.name
  location            = azurerm_resource_group.RG-BoomiServices.location
  depends_on          = [tls_private_key.BoomiNFSKey]
  public_key          = tls_private_key.BoomiNFSKey.public_key_openssh
  tags                = local.CommonTags
}


# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "NSG-Association" {
  network_interface_id      = azurerm_network_interface.NFSServer-PrivateIP-BoomiService.id
  network_security_group_id = azurerm_network_security_group.NSG-BoomiServices.id
  depends_on                = [azurerm_ssh_public_key.Boomi-NFS-SSH-Key]
}
