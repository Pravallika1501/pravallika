provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "azapi" {
  # Configuration options
}
terraform {
  backend "azurerm" {
    # # SubscriptionId for TF StateManagement
    subscription_id      = var.BuildAgent.SubscriptionId
    resource_group_name  = var.BuildAgent.ResourceGroupName
    storage_account_name = var.BuildAgent.StorageAccountName
    container_name       = lower(var.ProjectName)
    key                  = "${var.ProjectName}.tfstate"
    use_msi              = true
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.37.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.29.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "1.0.0"
    }
  }
}




