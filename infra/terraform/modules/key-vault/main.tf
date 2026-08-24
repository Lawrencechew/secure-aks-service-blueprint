resource "azurerm_key_vault" "this" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tenant_id                     = var.tenant_id
  sku_name                      = var.sku_name
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = var.purge_protection_enabled
  enable_rbac_authorization     = var.enable_rbac_authorization
  public_network_access_enabled = true
  tags                          = var.tags

  network_acls {
    bypass         = var.network_acls_bypass
    default_action = var.network_acls_default_action
    ip_rules       = var.network_acls_ip_rules
  }
}
