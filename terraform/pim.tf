

//https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#contributor
data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

//https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#key-vault-secrets-officer
data "azurerm_role_definition" "kvsecretsofficer" {
  name = "Key Vault Secrets Officer"
}

resource "time_static" "time" {}

resource "azurerm_pim_eligible_role_assignment" "subscription_contributor" {
  scope              = data.azurerm_subscription.primary.id
  role_definition_id = "${data.azurerm_subscription.primary.id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = "3270dd31-29ac-486d-8a16-e9179660c8d7"

  schedule {
    start_date_time = time_static.time.rfc3339
    expiration {
      duration_hours = 1
    }
  }

  justification = "Expiration Duration Set"

  ticket {
    number = "1"
    system = "example ticket system"
  }
}
