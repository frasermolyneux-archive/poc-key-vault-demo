locals {
  private_dns_zones = {
    "vault" = "privatelink.vaultcore.azure.net",
  }

  location_private_dns_zones = flatten([
    for location in var.locations : [
      for private_dns_zone_key, private_dns_zone in local.private_dns_zones : {
        key                  = format("%s-%s", private_dns_zone_key, location)
        location             = location
        private_dns_zone_key = private_dns_zone_key
        private_dns_zone     = private_dns_zone
      }
    ]
  ])
}

resource "azurerm_resource_group" "dns" {
  name     = format("rg-dns-%s-%s-%s", random_id.environment_id.hex, var.environment, var.primary_location)
  location = var.primary_location

  tags = var.tags
}

resource "azurerm_private_dns_zone" "dns" {
  for_each = { for key, value in local.private_dns_zones : key => value }

  name                = each.value
  resource_group_name = azurerm_resource_group.dns.name

  tags = var.tags
}
