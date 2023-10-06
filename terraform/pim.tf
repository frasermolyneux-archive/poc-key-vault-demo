
resource "time_static" "subscription_contributor" {}

resource "azurerm_pim_eligible_role_assignment" "subscription_contributor" {
  scope              = data.azurerm_subscription.primary.id
  role_definition_id = "${data.azurerm_subscription.primary.id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = "3270dd31-29ac-486d-8a16-e9179660c8d7"

  schedule {
    start_date_time = time_static.subscription_contributor.rfc3339
    expiration {
      duration_days = 30
    }
  }
}
