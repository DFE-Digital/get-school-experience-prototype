provider "cloudfoundry" {
  api_url  = var.api_url
  user     = local.infrastructure_secrets.PAAS-USERNAME
  password = local.infrastructure_secrets.PAAS-PASSWORD
}

locals {
  azure_credentials = jsondecode(var.AZURE_CREDENTIALS)
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
  subscription_id = local.azure_credentials.subscriptionId
  client_id       = local.azure_credentials.clientId
  client_secret   = local.azure_credentials.clientSecret
  tenant_id       = local.azure_credentials.tenantId
}

terraform {
  required_version = ">= 0.13.4"

  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "0.14.2"
    }
  }
}
