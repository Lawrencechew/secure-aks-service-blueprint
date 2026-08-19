variable "location" {
  type    = string
  default = "eastus"
}

variable "resource_group_name" {
  type    = string
  default = "secure-aks-rg"
}

variable "acr_name" {
  type    = string
  default = ""
}

variable "aks_cluster_name" {
  type    = string
  default = ""
}

variable "key_vault_name" {
  type    = string
  default = ""
}
