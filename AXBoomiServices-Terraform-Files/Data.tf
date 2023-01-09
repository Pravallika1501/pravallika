data "azurerm_subscription" "primary" {}

data "azurerm_client_config" "current" {}

data "azuread_service_principal" "BuildAgent" {
  display_name = var.BuildAgent.ApplicationName
}