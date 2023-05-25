resource "azurerm_resource_group" "kv_02" {
  for_each = toset(var.locations)

  name     = format("rg-kv-%s-%s-%s-02", random_id.environment_id.hex, var.environment, each.value)
  location = var.locations[0]

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

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = data.github_ip_ranges.gh.actions
  }
}

resource "azurerm_role_assignment" "kv_02_sp" {
  for_each = toset(var.locations)

  scope                = azurerm_key_vault.kv_02[each.value].id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "kv_02_demo" {
  for_each = toset(var.locations)

  scope                = azurerm_key_vault.kv_02[each.value].id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = "3270dd31-29ac-486d-8a16-e9179660c8d7"
}

resource "azurerm_key_vault_secret" "kv_02_example" {
  for_each = toset(var.locations)

  name         = "my-super-secret"
  value        = random_string.location[each.value].result
  key_vault_id = azurerm_key_vault.kv_02[each.value].id

  depends_on = [
    azurerm_role_assignment.kv_02_sp
  ]
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
      azurerm_private_dns_zone.vault.id,
    ]
  }

  private_service_connection {
    name                           = format("pe-%s-vault-02", azurerm_key_vault.kv_02[each.value].name)
    private_connection_resource_id = azurerm_key_vault.kv_02[each.value].id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
}
