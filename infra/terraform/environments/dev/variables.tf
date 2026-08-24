variable "location" {
  type    = string
  default = "eastus"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "resource_group_name" {
  type = string
}

variable "acr_name" {
  type = string
}

variable "aks_name" {
  type = string
}

variable "aks_dns_prefix" {
  type = string
}

variable "key_vault_name" {
  type = string
}

variable "uami_name" {
  type = string
}

variable "federated_credential_name" {
  type    = string
  default = "secure-service-fic"
}

variable "k8s_namespace" {
  type    = string
  default = "default"
}

variable "k8s_service_account_name" {
  type    = string
  default = "secure-service"
}

variable "acr_sku" {
  type    = string
  default = "Basic"
}

variable "acr_admin_enabled" {
  type    = bool
  default = false
}

variable "aks_node_count" {
  type    = number
  default = 2
}

variable "aks_node_vm_size" {
  type    = string
  default = "Standard_DS2_v2"
}

variable "aks_kubernetes_version" {
  type    = string
  default = null
}

variable "aks_api_server_authorized_ip_ranges" {
  type    = list(string)
  default = ["10.0.0.0/24"]
}

variable "key_vault_soft_delete_retention_days" {
  type    = number
  default = 7
}

variable "key_vault_purge_protection_enabled" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
