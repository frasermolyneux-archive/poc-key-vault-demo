
resource "time_static" "keyvault_contributor" {}

resource "azurerm_pim_eligible_role_assignment" "keyvault_contributor" {
  for_each = toset(var.locations)

  scope              = azurerm_key_vault.kv_01[each.value].id
  role_definition_id = "${data.azurerm_subscription.primary.id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = "3270dd31-29ac-486d-8a16-e9179660c8d7" // For demo purposes - this is fmolyneux@microsoft.com

  schedule {
    start_date_time = time_static.keyvault_contributor.rfc3339
    expiration {
      duration_days = 30
    }
  }
}

resource "time_static" "keyvault_secretofficer" {}

resource "azurerm_pim_eligible_role_assignment" "keyvault_secretofficer" {
  for_each = toset(var.locations)

  scope              = azurerm_key_vault.kv_01[each.value].id
  role_definition_id = "${data.azurerm_subscription.primary.id}${data.azurerm_role_definition.kvsecretsofficer.id}"
  principal_id       = "3270dd31-29ac-486d-8a16-e9179660c8d7" // For demo purposes - this is fmolyneux@microsoft.com

  schedule {
    start_date_time = time_static.keyvault_secretofficer.rfc3339
    expiration {
      duration_days = 30
    }
  }
}
