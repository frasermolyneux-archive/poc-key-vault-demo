terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.75.0"
    }
  }

  backend "azurerm" {}
}


provider "azurerm" {
  subscription_id = var.subscription_id

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

data "azurerm_subscription" "primary" {}

data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}

resource "random_id" "environment_id" {
  byte_length = 6
}

// Create a random string that will be used when creating resources to prevent naming conflicts
resource "random_string" "location" {
  for_each = toset(var.locations)

  length  = 10
  special = false
}

resource "time_rotating" "rotate" {
  rotation_days = 30
}
