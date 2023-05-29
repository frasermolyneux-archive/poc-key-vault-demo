resource "azurerm_key_vault_secret" "kv_01_example" {
  for_each = toset(var.locations)

  name         = "my-super-secret"
  value        = random_string.location[each.value].result
  key_vault_id = azurerm_key_vault.kv_01[each.value].id

  depends_on = [
    azurerm_role_assignment.kv_01_sp
  ]
}
