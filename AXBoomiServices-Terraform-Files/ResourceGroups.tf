resource "azurerm_resource_group" "RG-BoomiServices" {
  name     = "RG-${var.ProjectName}${local.ResourceSuffix}"
  location = var.Location
  tags     = local.CommonTags
}
