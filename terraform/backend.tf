terraform {
  backend "azurerm" {
    use_cli          = true
    use_azuread_auth = true

    container_name = "tfstate"
    key            = "epicbook.tfstate"
  }
}
