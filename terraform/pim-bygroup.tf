
// Create AAD Group
resource "azuread_group" "kvofficer_eligible_group" {
  display_name     = "keyvault-secret-officer-eligible"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

// Add member directly for demo
resource "azuread_group_member" "demo_membership" {
  group_object_id  = azuread_group.kvofficer_eligible_group.id
  member_object_id = "3270dd31-29ac-486d-8a16-e9179660c8d7"
}

// https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#key-vault-secrets-officer
data "azurerm_role_definition" "kvsecretsofficer" {
  name = "Key Vault Secrets Officer"
}

// Assign group to pim eligible
resource "azurerm_pim_eligible_role_assignment" "kvofficer_eligible_group" {
  for_each = toset(var.locations)

  scope              = azurerm_key_vault.kv_01[each.value].id
  role_definition_id = "${data.azurerm_subscription.primary.id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = azuread_group_member.demo_membership.member_object_id
}
