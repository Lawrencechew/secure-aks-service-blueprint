output "resource_group_name" {
  value = module.resource_group.name
}

output "acr_login_server" {
  value = module.acr.login_server
}

output "aks_name" {
  value = module.aks.name
}

output "aks_oidc_issuer_url" {
  value = module.aks.oidc_issuer_url
}

output "key_vault_name" {
  value = module.key_vault.name
}

output "key_vault_uri" {
  value = module.key_vault.vault_uri
}

output "workload_identity_client_id" {
  value = module.identity.client_id
}

output "workload_identity_federated_subject" {
  value = module.identity.federated_subject
}

output "workload_identity_service_account_name" {
  value = var.k8s_service_account_name
}

