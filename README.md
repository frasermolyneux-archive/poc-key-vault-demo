# POC - Key Vault Demo

This poc repository will create two demo Key Vaults:

* A public-network accessible Key Vault for demo of features/capabilities and Azure Pipelines integration.
* A private endpoint protected Key Vault for a demo of the private network features/capabilities.

---

## Further Considerations

Naturally, this is a limited architecture for the POC with many additional considerations required. Here are a few as a starting point:

* [Key Vault Best Practices](https://learn.microsoft.com/en-us/azure/key-vault/general/best-practices)
* [Key Vault Secrets Best Practices](https://learn.microsoft.com/en-us/azure/key-vault/secrets/secrets-best-practices)

---

## POC Scenarios

* General walkthrough of Key Vault features/capabilities.
* Key Vault integration with Azure Pipelines.
* Private endpoint integration with Key Vault.

---

## Azure Pipelines Integration Demo

[proof-of-concepts-management](https://github.com/frasermolyneux/proof-of-concepts-management) has created a service connection within the [frasermolyneux/MSFT](https://dev.azure.com/frasermolyneux/MSFT) AzDo project. This service connection is used to authenticate to the public Key Vault and retrieve a secret value.

Steps for running demos are in the two pipelines:

* [using-key-vault-task](.azure-pipelines/using-key-vault-task.yml)
* [using-variable-groups](.azure-pipelines/using-variable-groups.yml)

---

## ARM Integration Demo

These demos use the `key-vault-01.tf` resource which has the `enabled_for_template_deployment` property set to `true`. This allows the ARM template to retrieve secrets from the Key Vault during deployment.

Manual running:

```powershell
    az group create --name rg-arm-direct-ref --location uksouth
    az deployment group create --resource-group rg-arm-direct-ref --template-file main.json --parameters params.json
```
