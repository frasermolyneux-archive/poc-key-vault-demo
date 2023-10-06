
// Create AAD Group
resource "azuread_group" "kvofficer_eligible_group" {
  display_name     = "keyvault-secret-officer-eligible"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

// Add members directly for demo
resource "azuread_group_member" "demo_membership_msft" {
  group_object_id  = azuread_group.kvofficer_eligible_group.id
  member_object_id = "3270dd31-29ac-486d-8a16-e9179660c8d7"
}

resource "azuread_group_member" "demo_membership_mx" {
  group_object_id  = azuread_group.kvofficer_eligible_group.id
  member_object_id = "ad7a863d-b087-4df5-833e-2900d58b14d2"
}

// Assign group to pim eligible
resource "azurerm_pim_eligible_role_assignment" "kvofficer_eligible_group_kv01" {
  for_each = toset(var.locations)

  scope              = azurerm_key_vault.kv_01[each.value].id
  role_definition_id = "${data.azurerm_subscription.primary.id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = azuread_group.kvofficer_eligible_group.object_id

  schedule {
    expiration {
      duration_days = 14
    }
  }
}

resource "azurerm_pim_eligible_role_assignment" "kvofficer_eligible_group_kv02" {
  for_each = toset(var.locations)

  scope              = azurerm_key_vault.kv_02[each.value].id
  role_definition_id = "${data.azurerm_subscription.primary.id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = azuread_group.kvofficer_eligible_group.object_id

  schedule {
    expiration {
      duration_days = 14
    }
  }
}
