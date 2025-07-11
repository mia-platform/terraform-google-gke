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

resource "google_container_node_pool" "pools" {
  provider = google-beta
  for_each = local.node_pools

  project  = var.project_id
  location = var.location

  name    = each.key
  cluster = google_container_cluster.master.name
  management {
    auto_repair  = true
    auto_upgrade = var.autoupgrade_settings.enabled
  }

  initial_node_count = each.value.min_size == each.value.max_size ? null : each.value.min_size
  node_count         = each.value.min_size != each.value.max_size ? null : each.value.min_size

  dynamic "autoscaling" {
    for_each = each.value.min_size != each.value.max_size ? [each.value] : []
    content {
      min_node_count = autoscaling.value.min_size
      max_node_count = lookup(autoscaling.value, "max_size", autoscaling.value.min_size)
    }
  }

  upgrade_settings {
    strategy        = var.autoupgrade_settings.strategy
    max_surge       = var.autoupgrade_settings.strategy == "SURGE" ? (each.value.max_surge == 0 ? max(ceil(each.value.min_size / 4), 1) : each.value.max_surge) : null
    max_unavailable = var.autoupgrade_settings.strategy == "SURGE" ? each.value.max_unavailable : null

    dynamic "blue_green_settings" {
      for_each = var.autoupgrade_settings.strategy == "BLUE_GREEN" ? [1] : []

      content {

        standard_rollout_policy {
          batch_node_count    = var.autoupgrade_settings.batch_node_count
          batch_soak_duration = var.autoupgrade_settings.batch_soak_duration
        }

        node_pool_soak_duration = var.autoupgrade_settings.node_pool_soak_duration
      }
    }
  }

  node_locations = lookup(each.value, "node_locations", "") != "" ? split(",", each.value["node_locations"]) : null
  node_config {
    image_type   = each.value.machine_image
    machine_type = each.value.machine_type

    local_ssd_count  = 0
    disk_type        = each.value.disk_type
    disk_size_gb     = each.value.disk_size_gb
    min_cpu_platform = each.value.min_cpu_platform
    preemptible      = each.value.preemptible
    spot             = each.value.spot

    service_account = each.value.service_account
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    dynamic "sandbox_config" {
      for_each = tobool((lookup(each.value, "sandbox_enabled", false))) ? ["gvisor"] : []
      content {
        sandbox_type = sandbox_config.value
      }
    }

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    dynamic "taint" {
      for_each = lookup(var.node_pools_taints, each.key, [])
      content {
        effect = taint.value.effect
        key    = taint.value.key
        value  = taint.value.value
      }
    }

    labels = lookup(var.node_pools_labels, each.key, var.defaults_node_pools_labels)
    tags   = lookup(var.node_pools_tags, each.key, var.defaults_node_pools_tags)
    metadata = {
      "disable-legacy-endpoints" = true
    }
  }

  lifecycle {
    ignore_changes = [
      initial_node_count,
      node_config["taint"],
      management["auto_upgrade"]
    ]
  }

  timeouts {
    create = "45m"
    update = "45m"
    delete = "45m"
  }
}
