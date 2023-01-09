locals {
  StorageSuffix  = "${lower(var.CountryCode)}${lower(var.ProjectNameShortCut)}${lower(terraform.workspace)}"
  ResourceSuffix = "-${var.CountryCode}-${var.ProjectNameShortCut}-${terraform.workspace}"
  CommonTags = {
    Country     = var.CountryCode
    Environment = terraform.workspace
    Project     = var.ProjectName
  }

  CidrNewBits = 24 - split("/", var.VNetAddressSpace)[1]
  SubNets     = cidrsubnets(var.VNetAddressSpace, local.CidrNewBits - 2, local.CidrNewBits, local.CidrNewBits, local.CidrNewBits)

  current_timestamp = timestamp()
  today             = formatdate("YYYY-MM-DD", timeadd(local.current_timestamp, "87600h")) # max. 360 days 
}
