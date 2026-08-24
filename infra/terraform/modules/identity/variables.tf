variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "federated_credential_name" {
  type = string
}

variable "oidc_issuer_url" {
  type = string
}

variable "k8s_namespace" {
  type = string
}

variable "k8s_service_account_name" {
  type = string
}

variable "audience" {
  type    = list(string)
  default = ["api://AzureADTokenExchange"]
}

variable "tags" {
  type    = map(string)
  default = {}
}

