resource "azurerm_resource_group" "kv_01" {
  for_each = toset(var.locations)

  name     = format("rg-kv-%s-%s-%s-01", random_id.environment_id.hex, var.environment, each.value)
  location = var.locations[0]

  tags = var.tags
}

resource "azurerm_key_vault" "kv_01" {
  for_each = toset(var.locations)

  name                = format("kv%s%s01", lower(random_string.location[each.value].result), var.environment)
  location            = azurerm_resource_group.kv_01[each.value].location
  resource_group_name = azurerm_resource_group.kv_01[each.value].name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  soft_delete_retention_days = 7

  enable_rbac_authorization = true
  purge_protection_enabled  = true

  sku_name = "standard"
}

resource "azurerm_role_assignment" "kv_01_sp" {
  for_each = toset(var.locations)

  scope                = azurerm_key_vault.kv_01[each.value].id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "kv_01_demo" {
  for_each = toset(var.locations)

  scope                = azurerm_key_vault.kv_01[each.value].id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = "3270dd31-29ac-486d-8a16-e9179660c8d7"
}

resource "azurerm_key_vault_secret" "kv_01_example" {
  for_each = toset(var.locations)

  name         = "my-super-secret"
  value        = random_string.location[each.value].result
  key_vault_id = azurerm_key_vault.kv_01[each.value].id

  depends_on = [
    azurerm_role_assignment.kv_01_sp
  ]
}
