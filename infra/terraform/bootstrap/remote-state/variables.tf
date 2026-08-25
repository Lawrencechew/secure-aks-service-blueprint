variable "location" {
  type    = string
  default = "eastus"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for Terraform state."
}

variable "storage_account_name_prefix" {
  type        = string
  description = "Prefix used to generate the globally unique storage account name."
}

variable "container_name" {
  type    = string
  default = "tfstate"
}

variable "allowed_ip_ranges" {
  type        = list(string)
  default     = []
  description = "CIDR ranges allowed to access the state storage account (for example your public IP /32)."
}

variable "tags" {
  type    = map(string)
  default = {}
}
