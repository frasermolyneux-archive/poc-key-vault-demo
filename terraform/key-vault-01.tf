resource "azurerm_resource_group" "kv_01" {
  for_each = toset(var.locations)

  name     = format("rg-kv-%s-%s-%s-01", random_id.environment_id.hex, var.environment, each.value)
  location = var.locations[0]

  tags = var.tags
}

resource "azurerm_key_vault" "kv_01" {
  for_each = toset(var.locations)

  name                = format("kv%s%s%s01", random_id.environment_id.hex, var.environment, each.value)
  location            = azurerm_resource_group.kv_01[each.value].location
  resource_group_name = azurerm_resource_group.kv_01[each.value].name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  soft_delete_retention_days = 7

  enabled_for_disk_encryption = true
  purge_protection_enabled    = true

  sku_name = "standard"
}
