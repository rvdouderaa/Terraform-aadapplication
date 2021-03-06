provider "azurerm" {
  version = "=1.42.0"
  subscription_id = var.subscription_id
}

locals {

  end_date = timeadd(timestamp(), "9000h")

}

resource "azuread_application" "AADApplication" {
  name                       = "${var.workloadName}-${var.environment}-${var.postfix}"
  identifier_uris            = ["https://www.simac.com/${var.workloadName}-${var.environment}-${var.postfix}"]
  reply_urls                 = [var.replyUrl]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = false    
}

resource "random_password" "default" {
  length  = 33
  special = true
}

resource "azuread_application_password" "default" {
  application_object_id = azuread_application.AADApplication.id
  value                 = random_password.default.result
  end_date              = local.end_date
}

resource "azuread_service_principal" "default" {
  application_id = azuread_application.AADApplication.application_id
  tags  = []
}

output "applicationID" {
  value = azuread_application.AADApplication.application_id
}

output "Secret" {
  value = random_password.default.result
}

output "ValidThru" {
  value = azuread_application_password.default.end_date
}
