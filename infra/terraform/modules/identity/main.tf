resource "azurerm_user_assigned_identity" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_federated_identity_credential" "this" {
  name                = var.federated_credential_name
  resource_group_name = var.resource_group_name
  audience            = var.audience
  issuer              = var.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.this.id
  subject             = "system:serviceaccount:${var.k8s_namespace}:${var.k8s_service_account_name}"
}

