resource "azurerm_role_assignment" "kv_02_demo" {
  for_each = toset(var.locations)

  scope                = azurerm_key_vault.kv_02[each.value].id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = "3270dd31-29ac-486d-8a16-e9179660c8d7"
}

resource "azurerm_role_assignment" "kv_02_demo_io" {
  for_each = toset(var.locations)

  scope                = azurerm_key_vault.kv_02[each.value].id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = "ad7a863d-b087-4df5-833e-2900d58b14d2"
}
