resource "azurerm_role_assignment" "kv_01_sp" {
  for_each = toset(var.locations)

  scope                = azurerm_key_vault.kv_01[each.value].id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "kv_01_demo" {
  for_each = toset(var.locations)

  scope                = azurerm_key_vault.kv_01[each.value].id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = "3270dd31-29ac-486d-8a16-e9179660c8d7"
}

resource "azurerm_role_assignment" "kv_01_demo_io" {
  for_each = toset(var.locations)

  scope                = azurerm_key_vault.kv_01[each.value].id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = "3270dd31-29ac-486d-8a16-e9179660c8d7"
}
