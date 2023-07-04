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
  provider = google
  for_each = local.node_pools

  project  = var.project_id
  location = var.location

  name    = each.key
  cluster = google_container_cluster.master.name
  management {
    auto_repair  = true
    auto_upgrade = false
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
    max_surge       = each.value.max_surge == 0 ? max(ceil(each.value.min_size / 4), 1) : each.value.max_surge
    max_unavailable = each.value.max_unavailable
  }

  node_locations = lookup(each.value, "node_locations", "") != "" ? split(",", each.value["node_locations"]) : null
  node_config {
    image_type   = each.value.machine_image
    machine_type = each.value.machine_type

    local_ssd_count  = 0
    disk_size_gb     = each.value.disk_size_gb
    disk_type        = "pd-standard"
    min_cpu_platform = each.value.min_cpu_platform
    preemptible      = each.value.preemptible
    spot             = each.value.spot

    service_account = each.value.service_account
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    taint  = lookup(var.node_pools_taints, each.key, [])
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
    ]
  }

  timeouts {
    create = "45m"
    update = "45m"
    delete = "45m"
  }
}
