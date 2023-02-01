provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "AD" {
  location = var.location
  name     = "${var.prefix}-rg"
}

module "network" {
  source = "./modules/network"

  location            = var.location
  prefix              = var.prefix
  resource_group_name = azurerm_resource_group.AD.name
}

module "active-directory-domain" {
  source = "./modules/active-directory-domain"

  resource_group_name = azurerm_resource_group.AD.name
  location            = azurerm_resource_group.AD.location

  active_directory_domain_name  = "${var.prefix}.local"
  active_directory_netbios_name = var.prefix
  admin_username                = var.admin_username
  admin_password                = var.admin_password
  prefix                        = var.prefix
  subnet_id                     = module.network.domain_controllers_subnet_id
}

