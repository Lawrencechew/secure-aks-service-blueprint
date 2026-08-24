resource "azurerm_kubernetes_cluster" "this" {
  name                              = var.name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  dns_prefix                        = var.dns_prefix
  kubernetes_version                = var.kubernetes_version
  oidc_issuer_enabled               = var.enable_oidc_issuer
  workload_identity_enabled         = var.enable_workload_identity
  role_based_access_control_enabled = true
  tags                              = var.tags

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.node_vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  api_server_access_profile {
    authorized_ip_ranges = var.api_server_authorized_ip_ranges
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }
}
