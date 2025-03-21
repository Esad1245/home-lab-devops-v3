provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
  numeric = true
}

resource "azurerm_resource_group" "rg" {
  name     = "home-lab-rg"
  location = "West Europe"
}

resource "azurerm_container_registry" "acr" {
  name                = "devopsacr${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "home-lab-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "homelabaks"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id

  lifecycle {
    ignore_changes = [name]
  }
}
resource "azurerm_key_vault" "devops_vault" {
  name                = "devops-keyvault-${random_string.suffix.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = var.azure_tenant_id
  sku_name            = "standard"
}

resource "azurerm_key_vault_access_policy" "terraform_policy" {
  key_vault_id = azurerm_key_vault.devops_vault.id
  tenant_id    = var.azure_tenant_id
  object_id    = "84c217aa-649b-40d6-89ee-51e12290a449"

  secret_permissions = ["Get", "List", "Set", "Delete"]
}

resource "azurerm_key_vault_access_policy" "aks_policy" {
  key_vault_id = azurerm_key_vault.devops_vault.id
  tenant_id    = var.azure_tenant_id
  object_id    = azurerm_kubernetes_cluster.aks.identity[0].principal_id

  secret_permissions = ["Get", "List", "Set", "Delete"]
}

resource "azurerm_key_vault_access_policy" "devops_automation_policy" {
  key_vault_id = azurerm_key_vault.devops_vault.id
  tenant_id    = var.azure_tenant_id
  object_id    = "f18ecbc2-ac3c-4ff5-a416-388140546f7e"

  secret_permissions = ["Get", "List", "Set", "Delete"]
}

resource "azurerm_key_vault_secret" "acr_username" {
  name         = "acr-username"
  value        = azurerm_container_registry.acr.admin_username
  key_vault_id = azurerm_key_vault.devops_vault.id
  depends_on   = [azurerm_container_registry.acr]
}

resource "azurerm_key_vault_secret" "acr_password" {
  name         = "acr-password"
  value        = azurerm_container_registry.acr.admin_password
  key_vault_id = azurerm_key_vault.devops_vault.id
  depends_on   = [azurerm_container_registry.acr]
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "home-lab-logs"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "aks_monitoring" {
  name                       = "aks-monitoring"
  target_resource_id         = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

resource "kubernetes_manifest" "ingress_nginx" {
  manifest   = yamldecode(file("${path.module}/k8s/nginx-ingress-controller.yaml"))
  depends_on = [azurerm_kubernetes_cluster.aks]
}