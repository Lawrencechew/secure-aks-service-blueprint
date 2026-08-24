variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "sku_name" {
  type    = string
  default = "standard"
}

variable "soft_delete_retention_days" {
  type    = number
  default = 7
}

variable "purge_protection_enabled" {
  type    = bool
  default = true
}

variable "enable_rbac_authorization" {
  type    = bool
  default = true
}

variable "network_acls_bypass" {
  type    = string
  default = "AzureServices"
}

variable "network_acls_default_action" {
  type    = string
  default = "Deny"
}

variable "network_acls_ip_rules" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
