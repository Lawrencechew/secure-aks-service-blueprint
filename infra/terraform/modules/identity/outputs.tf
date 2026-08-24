output "id" {
  value = azurerm_user_assigned_identity.this.id
}

output "client_id" {
  value = azurerm_user_assigned_identity.this.client_id
}

output "principal_id" {
  value = azurerm_user_assigned_identity.this.principal_id
}

output "federated_subject" {
  value = "system:serviceaccount:${var.k8s_namespace}:${var.k8s_service_account_name}"
}

