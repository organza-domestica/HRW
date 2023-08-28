
resource "azurerm_user_assigned_identity" "az-lx-id-aks-insights" {
  name                = "az-lx-id-hrw-${var.environment}-aks-insights"
  resource_group_name = var.resource_group_name
  location            = var.location
}


resource "azurerm_kubernetes_cluster" "k8s" {
  name                   = var.cluster_name
  location               = var.location
  resource_group_name    = var.resource_group_name
  dns_prefix             = var.dns_prefix
  kubernetes_version     = "1.25.5"
  oidc_issuer_enabled    = true
  local_account_disabled = true

  azure_active_directory_role_based_access_control {
    managed = true
    admin_group_object_ids = [
      var.admin_group_object_id
    ]
    azure_rbac_enabled = true
  }

  network_profile {
    network_plugin = "none"
    outbound_type = "userDefinedRouting"
  }

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }
  identity {
    type = "UserAssigned"
    identity_ids = [
      #      azurerm_user_assigned_identity.az-lx-mi-aks-insights.id,
      var.umi_id
    ]
  }

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  default_node_pool {
    name                  = "default"
    node_count            = var.agent_count
    vm_size               = "Standard_B2ms"
    os_disk_size_gb       = 30
    vnet_subnet_id        = var.virtual_network_subnet_id
    enable_auto_scaling   = false
    enable_node_public_ip = false
    orchestrator_version  = "1.25.5"
  }

  private_cluster_enabled             = var.private_cluster_enabled
  private_dns_zone_id                 = var.private_cluster_enabled ? "None" : null
  private_cluster_public_fqdn_enabled = var.private_cluster_enabled ? true : false
}

resource "azurerm_monitor_diagnostic_setting" "k8s_logs" {
  name                       = "logs"
  target_resource_id         = azurerm_kubernetes_cluster.k8s.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "guard"

    retention_policy {
      enabled = false
    }
  }
  enabled_log {
    category = "kube-apiserver"

    retention_policy {
      enabled = false
    }
  }
  enabled_log {
    category = "kube-controller-manager"

    retention_policy {
      enabled = false
    }
  }
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}
