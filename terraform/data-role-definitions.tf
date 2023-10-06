//https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#contributor
data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

//https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#key-vault-secrets-officer
data "azurerm_role_definition" "kvsecretsofficer" {
  name = "Key Vault Secrets Officer"
}
