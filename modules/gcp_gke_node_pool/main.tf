/*
   Copyright 2019 Mia srl

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

terraform {
  required_version = ">= 0.12"
  required_providers {
    google-beta = "~> 2.20"
  }
}

locals {
  pool_map = { for pool in var.node_pools : pool.name => pool }
}

resource "google_container_node_pool" "node_pool" {
  provider = google-beta
  for_each = local.pool_map

  name       = each.key
  location   = var.zone
  project    = var.project_id
  cluster    = var.cluster_name
  node_count = each.value.node_count

  node_config {
    preemptible  = false
    machine_type = each.value.machine_type
    disk_size_gb = 50
    image_type   = "COS"

    shielded_instance_config {
      enable_secure_boot = true
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }

    service_account = var.service_account_email
    oauth_scopes = [
      "cloud-platform"
    ]

    tags   = each.value.tags
    labels = each.value.labels

    min_cpu_platform = lookup(each.value, "min_cpu_platform", "")
  }

  management {
    auto_repair  = true
    auto_upgrade = false
  }
}
