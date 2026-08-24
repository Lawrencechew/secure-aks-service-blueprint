variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "kubernetes_version" {
  type    = string
  default = null
}

variable "node_count" {
  type    = number
  default = 2
}

variable "node_vm_size" {
  type    = string
  default = "Standard_DS2_v2"
}

variable "enable_oidc_issuer" {
  type    = bool
  default = true
}

variable "enable_workload_identity" {
  type    = bool
  default = true
}

variable "api_server_authorized_ip_ranges" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
