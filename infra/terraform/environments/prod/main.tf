locals {
  tags = merge(var.tags, {
    environment = var.environment
    managed-by  = "terraform"
    project     = "secure-aks-service-blueprint"
  })
}

module "resource_group" {
  source   = "../../modules/resource-group"
  name     = var.resource_group_name
  location = var.location
  tags     = local.tags
}

module "acr" {
  source              = "../../modules/acr"
  name                = var.acr_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
  tags                = local.tags
}

module "aks" {
  source                          = "../../modules/aks"
  name                            = var.aks_name
  resource_group_name             = module.resource_group.name
  location                        = module.resource_group.location
  dns_prefix                      = var.aks_dns_prefix
  kubernetes_version              = var.aks_kubernetes_version
  node_count                      = var.aks_node_count
  node_vm_size                    = var.aks_node_vm_size
  enable_oidc_issuer              = true
  enable_workload_identity        = true
  api_server_authorized_ip_ranges = var.aks_api_server_authorized_ip_ranges
  tags                            = local.tags
}

module "key_vault" {
  source                     = "../../modules/key-vault"
  name                       = var.key_vault_name
  resource_group_name        = module.resource_group.name
  location                   = module.resource_group.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = var.key_vault_soft_delete_retention_days
  purge_protection_enabled   = var.key_vault_purge_protection_enabled
  enable_rbac_authorization  = true
  tags                       = local.tags
}

module "identity" {
  source                    = "../../modules/identity"
  name                      = var.uami_name
  resource_group_name       = module.resource_group.name
  location                  = module.resource_group.location
  federated_credential_name = var.federated_credential_name
  oidc_issuer_url           = module.aks.oidc_issuer_url
  k8s_namespace             = var.k8s_namespace
  k8s_service_account_name  = var.k8s_service_account_name
  tags                      = local.tags
}

# Required for AKS node pulls from ACR.
resource "azurerm_role_assignment" "aks_kubelet_acr_pull" {
  scope                = module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_identity_object_id
}

# Required for workload identity-based Key Vault secret reads.
resource "azurerm_role_assignment" "secure_service_kv_secrets_user" {
  scope                = module.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.identity.principal_id
}
