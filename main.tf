
resource "azurerm_resource_group" "lne_rg" {
  name     = "lne-rg"
  location = "Central India"
}

resource "azurerm_container_registry" "acr" {
  name                = "lnecontainerRegistry"
  resource_group_name = azurerm_resource_group.lne_rg.name
  location            = azurerm_resource_group.lne_rg.location
  sku                 = "Standard"
  admin_enabled       = true

  lifecycle {
    ignore_changes = all
  }

  tags = {
    "Business unit" = "Devops"
    "Cost Center"   = "420"
  }
}

resource "azurerm_service_plan" "node_app_plan" {
  name                = "node-app-plan"
  resource_group_name = azurerm_resource_group.lne_rg.name
  location            = azurerm_resource_group.lne_rg.location
  os_type             = "Linux"
  sku_name            = "B1"

  tags = {
    "Business unit" = "Devops"
    "Cost Center"   = "420"
  }

}

resource "azurerm_linux_web_app" "node_app" {
  name                = "lnenodeapplication"
  resource_group_name = azurerm_resource_group.lne_rg.name
  location            = azurerm_service_plan.node_app_plan.location
  service_plan_id     = azurerm_service_plan.node_app_plan.id

  site_config {
    application_stack {
      docker_image_name = "node-app:1.0"
    }
  }

  lifecycle {
    ignore_changes = all
  }

  tags = {
    "Business unit" = "Devops"
    "Cost Center"   = "420"
  }

}

# resource "azurerm_container_group" "react_app" {
#   name                = "lne-react-app"
#   location            = azurerm_resource_group.lne_rg.location
#   resource_group_name = azurerm_resource_group.lne_rg.name
#   ip_address_type     = "Public"
#   dns_name_label      = "lnereact"
#   os_type             = "Linux"

#   container {
#     name   = "react-app"
#     image  = "lnecontainerregistry.azurecr.io/react-app:1.0"
#     cpu    = "0.5"
#     memory = "1.5"

#     ports {
#       port     = 80
#       protocol = "TCP"
#     }

#     environment_variables = {
#       API_BASE_URL = "http://lnenodeapplication.azurewebsites.net"
#     }
#   }

#   image_registry_credential {
#     server   = "lnecontainerregistry.azurecr.io"
#     username = var.username
#     password = var.password
#   }

#   lifecycle {
#     ignore_changes = all
#   }

#   tags = {
#     "Business unit" = "Devops"
#     "Cost Center"   = "420"
#   }
# }

resource "azurerm_container_group" "my_container_app" {
  name                = "lne-react-app"
  location            = "centralindia"
  resource_group_name = "lne-rg"
  dns_name_label      = "lnereact"
  os_type             = "Linux"

  container {
    name   = "react-app"
    image  = "lnecontainerregistry.azurecr.io/react-app:1.0"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
  tags = {
    "Business unit" = "Devops"
    "Cost Center"   = "420"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_postgresql_flexible_server" "postgres_flex_server" {
  name                   = "lnepostgresserver"
  resource_group_name    = azurerm_resource_group.lne_rg.name
  location               = azurerm_resource_group.lne_rg.location
  version                = "16"
  administrator_login    = var.db_username
  administrator_password = var.db_password
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
  zone                   = 2

  lifecycle {
    ignore_changes = all
  }

  tags = {
    "Business unit" = "Devops"
    "Cost Center"   = "420"
  }
}

resource "azurerm_postgresql_flexible_server_database" "lne_db" {
  name      = "lne-db"
  server_id = azurerm_postgresql_flexible_server.postgres_flex_server.id
  collation = "en_US.utf8"
  charset   = "utf8"
}