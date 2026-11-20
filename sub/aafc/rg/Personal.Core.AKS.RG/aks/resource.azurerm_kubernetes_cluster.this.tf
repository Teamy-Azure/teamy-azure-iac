resource "azurerm_kubernetes_cluster" "this" {
  name = "Personal-AKS"
  dns_prefix = "personal-aks"
  resource_group_name = data.azurerm_resource_group.main.name
  location = "canadacentral"
  tags = {
    partition  = "Personal"
    managed_by = "Terraform"
    purpose    = "Personal AKS and core NGINX storage"
  }
  node_resource_group = "Personal.Core.AKS.Nodes.RG"
  kubernetes_version = "1.35.8"
  sku_tier = "Free"
  support_plan = "KubernetesOfficial"
  oidc_issuer_enabled = true
  workload_identity_enabled = true
  role_based_access_control_enabled = true
  local_account_disabled = true
  run_command_enabled = false
  node_os_upgrade_channel = "NodeImage"

  api_server_access_profile {
    authorized_ip_ranges = ["${trimspace(data.http.public_ip.response_body)}/32"]
  }
  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = true
    admin_group_object_ids = ["7925a047-b9c8-408b-9cbf-91b73758db87"]
  }
  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.control_plane.id]
  }
  default_node_pool {
    name = "system"
    node_count = 1
    vm_size = "Standard_D4s_v5"
    os_sku = "Ubuntu"
    vnet_subnet_id = data.azurerm_subnet.aks.id
    orchestrator_version = "1.35.8"
    temporary_name_for_rotation = "systemtemp"
    max_pods = 110
    upgrade_settings { max_surge = "10%" }
  }
  network_profile {
    network_plugin = "azure"
    network_plugin_mode = "overlay"
    pod_cidr = "10.242.0.0/16"
    service_cidr = "10.243.0.0/16"
    dns_service_ip = "10.243.0.10"
    load_balancer_sku = "standard"
    outbound_type = "loadBalancer"
    load_balancer_profile { managed_outbound_ip_count = 1 }
  }
  storage_profile {
    blob_driver_enabled = true
    disk_driver_enabled = true
    file_driver_enabled = true
    snapshot_controller_enabled = true
  }
  depends_on = [azurerm_role_assignment.subnet_network_contributor]
  lifecycle { prevent_destroy = true }
}
