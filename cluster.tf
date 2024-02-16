/*
   Copyright 2020 Mia srl

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

resource "google_container_cluster" "master" {
  provider       = google-beta
  project        = data.google_project.prj.project_id
  location       = var.location
  node_locations = var.zones

  name                      = var.name
  description               = var.description
  min_master_version        = local.min_master_version
  default_max_pods_per_node = 110

  release_channel {
    channel = "UNSPECIFIED"
  }

  cluster_autoscaling {
    enabled = false
  }

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = data.google_compute_subnetwork.subnetwork.network
  subnetwork = data.google_compute_subnetwork.subnetwork.self_link

  binary_authorization {
    evaluation_mode = "DISABLED"
  }

  enable_intranode_visibility = false
  enable_shielded_nodes       = var.enable_shielded_nodes
  enable_kubernetes_alpha     = false
  enable_legacy_abac          = false
  enable_tpu                  = false

  logging_service    = "none"
  monitoring_service = "none"

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.maintenance_start_time
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = var.enable_private_only_api_server
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
    master_global_access_config {
      enabled = var.master_global_access
    }
  }

  dynamic "master_authorized_networks_config" {
    for_each = local.master_authorized_networks_config
    content {
      dynamic "cidr_blocks" {
        for_each = master_authorized_networks_config.value.cidr_blocks
        content {
          cidr_block   = lookup(cidr_blocks.value, "cidr_block", "")
          display_name = lookup(cidr_blocks.value, "display_name", "")
        }
      }
    }
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  dynamic "authenticator_groups_config" {
    for_each = local.authenticator_security_group
    content {
      security_group = authenticator_groups_config.value
    }
  }

  network_policy {
    enabled  = local.gke_calico_enabled.enabled
    provider = local.gke_calico_enabled.provider
  }

  pod_security_policy_config {
    enabled = var.enable_pod_security_policies
  }

  workload_identity_config {
    workload_pool = local.workload_identity_namespace
  }

  vertical_pod_autoscaling {
    enabled = var.vertical_pod_autoscaling_enabled
  }

  monitoring_config {
    managed_prometheus {
      enabled = false
    }
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = false
    }

    network_policy_config {
      disabled = local.gke_calico_enabled.enabled ? false : true
    }

    istio_config {
      disabled = true
    }

    cloudrun_config {
      disabled = true
    }

    dns_cache_config {
      enabled = false
    }

    gce_persistent_disk_csi_driver_config {
      enabled = var.csi_driver_enabled
    }

    kalm_config {
      enabled = false
    }

    config_connector_config {
      enabled = false
    }
  }

  default_snat_status {
    disabled = false
  }

  resource_labels = var.labels

  timeouts {
    create = "45m"
    update = "45m"
    delete = "45m"
  }

  lifecycle {
    ignore_changes = [
      node_pool,
      initial_node_count,
      min_master_version,
      binary_authorization,
      node_pool_auto_config,
      node_pool_defaults
    ]
  }
}
