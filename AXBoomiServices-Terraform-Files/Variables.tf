####Below All Names mentioned in terraform.tfvars file not hardcoted here
variable "SubscriptionId" {
  description = "Target Boomi Services SubscriptionID"
}

variable "CountryCode" {
  description = "Country Code (2 Letter)"
}

variable "Location" {
  description = "location"
}

variable "ProjectName" {
  description = "Project Name"
}

variable "ProjectNameShortCut" {
  description = "Project name shortcut"
}

variable "VNetAddressSpace" {
  description = "Virtual Network Address Space"
}

variable "GrafanaSettings" {
  description = "Boomi Services Grafana"
  type = object({
    location = string
  })
  default = {
    location = "australiaeast"
  }
}

variable "BuildAgent" {
  description = "Build Agent details"
  type = object({
    SubscriptionId     = string
    ApplicationName    = string
    StorageAccountName = string
    ResourceGroupName  = string
    VirtualNetworkName = string
    SubNetName         = string
    NatPublicIpName    = string
  })
  default = {
    SubscriptionId     = "af715814-d97c-47e6-9791-e888c3a54290"
    ApplicationName    = "AzureDevOps-AustraliaBuildAgent"
    StorageAccountName = "stdevopsauprod"
    ResourceGroupName  = "RG-DevOps-AU-Prod"
    VirtualNetworkName = "VNet-DevOps-AU-Prod"
    SubNetName         = "agents"
    NatPublicIpName    = "IP-NAT-DevOps-AU-Prod"
  }
}
######Storage Account Settings############
variable "StorageAccountSettings" {
  description = "Boomi Services Storage Account"
  type = object({
    Accounttier     = string
    ReplicationType = string
    TLSVersion      = string
    RetentionPolicy = number
    enabled         = bool
    days            = number
    version         = string
    include_apis    = bool
    delete          = bool
    read            = bool
    write           = bool

  })
  default = {
    Accounttier     = "Standard"
    ReplicationType = "GRS"
    TLSVersion      = "TLS1_2"
    RetentionPolicy = "7.0"
    days            = 30
    enabled         = false
    version         = "1.0"
    include_apis    = false
    delete          = true
    read            = true
    write           = true
  }
}
#####Virtual Machine Settings ######
variable "VirtualMachineSettings" {
  description = "Boomi Services NFS Server"
  type = object({
    DiskLUN         = string
    DiskCaching     = string
    StorageType     = string
    NFSDataDiskSize = number
    NFSVMSize       = string
    UserName        = string
  })
  default = {
    DiskLUN         = "0"
    DiskCaching     = "ReadWrite"
    StorageType     = "Premium_LRS"
    NFSDataDiskSize = "512"
    NFSVMSize       = "Standard_E2s_v3"
    UserName        = "boominfsadmin"
  }
}

#####Azure Firewall #####

variable "FirewallSettings" {
  description = "Boomi Services Firewall"
  type = object({
    Allocation = string
    SKUTier    = string
    Name       = string
  })
  default = {
    Allocation = "Static"
    SKUTier    = "Standard"
    Name       = "AzureFirewallSubnet"
  }
}

#####Boomi Services Key Vault #####

variable "KeyVaultSettings" {
  description = "Boomi Services Key Vault Settings"
  type = object({
    SetTrue = bool
    SKU     = string
  })
  default = {
    SetTrue = true
    SKU     = "premium"
  }
}

#####AKS Cluster ###

variable "AKSSettings" {
  description = "AKSSettings"
  type = object({
    Version            = string
    NodeCount          = number
    OSPool             = string
    MaxNodeCount       = number
    MinNodeCount       = number
    CIDR               = string
    NetworkPluginType  = string
    NetworkPolicy      = string
    DNSServiceIP       = string
    DockerBridgeCIDR   = string
    LBSKU              = string
    NodeSize           = string
    AdminSize          = string
    DiskSize           = string
    DeploymentName     = string
    MonitoringPoolName = string
  })
  default = {
    Version            = "1.24.6"
    NodeCount          = "1"
    OSPool             = "Linux"
    MaxNodeCount       = "1"
    MinNodeCount       = "1"
    CIDR               = "10.92.10.0/24"
    NetworkPluginType  = "azure"
    NetworkPolicy      = "azure"
    DNSServiceIP       = "10.92.10.10"
    DockerBridgeCIDR   = "172.32.0.1/16"
    LBSKU              = "standard"
    NodeSize           = "Standard_E4s_v3"
    AdminSize          = "Standard_D4s_v3"
    DiskSize           = "256"
    DeploymentName     = "boomipool"
    MonitoringPoolName = "grafanapool"
  }
}

####Log Analitics####

variable "ContainerInsights" {
  type        = string
  description = "Container Insights Name"
}
variable "RetentionPeriod" {
  type        = string
  description = "Log Analytices Retail Period"
}

#####ACR and User Identity#########
variable "ACRSku" {
  type        = string
  description = "CWR ACR SKU Tier"
}


