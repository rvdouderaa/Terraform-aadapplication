provider "azurerm" {
  version = "=1.42.0"
  subscription_id = var.subscription_id
}


resource "azuread_application" "example" {
  name                       = "myTestapplication"
  identifier_uris            = ["https://www.simac.com/myTestApplication"]
  reply_urls                 = ["https://localhost"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = false    
}


resource "random_password" "default" {
  length  = 33
  special = true
}

resource "azuread_application_password" "default" {
  application_object_id = azuread_application.example.id
  value                 = random_password.default.result
  end_date              = "2040-01-01T01:02:03Z"
}

resource "azuread_service_principal" "default" {
  application_id = azuread_application.example.application_id
  tags  = []
}

