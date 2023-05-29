resource "azurerm_resource_group" "kv_02" {
  for_each = toset(var.locations)

  name     = format("rg-kv-%s-%s-%s-02", random_id.environment_id.hex, var.environment, each.value)
  location = each.value

  tags = var.tags
}

resource "azurerm_key_vault" "kv_02" {
  for_each = toset(var.locations)

  name                = format("kv%s%s02", lower(random_string.location[each.value].result), var.environment)
  location            = azurerm_resource_group.kv_02[each.value].location
  resource_group_name = azurerm_resource_group.kv_02[each.value].name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  soft_delete_retention_days = 7

  enable_rbac_authorization = true
  purge_protection_enabled  = true

  sku_name = "standard"

  public_network_access_enabled = false
  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}

resource "azurerm_private_endpoint" "kv_02" {
  for_each = toset(var.locations)

  name = format("pe-%s-vault-02", azurerm_key_vault.kv_02[each.value].name)

  resource_group_name = azurerm_resource_group.kv_02[each.value].name
  location            = azurerm_resource_group.kv_02[each.value].location

  subnet_id = azurerm_subnet.endpoints[each.value].id

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.dns["vault"].id,
    ]
  }

  private_service_connection {
    name                           = format("pe-%s-vault-02", azurerm_key_vault.kv_02[each.value].name)
    private_connection_resource_id = azurerm_key_vault.kv_02[each.value].id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
}
