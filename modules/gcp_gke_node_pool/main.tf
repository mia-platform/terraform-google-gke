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
    google = "~> 2.19.0"
  }
}

resource "google_container_node_pool" "node_pool" {
  count = length(var.node_pools)

  name       = replace(".", "", "${var.node_pools[count.index].name}-${var.gke_version}")
  location   = var.zone
  project    = var.project_id
  cluster    = var.cluster_name
  node_count = var.node_pools[count.index].node_count

  node_config {
    preemptible  = false
    machine_type = var.node_pools[count.index].machine_type
    disk_size_gb = 50
    image_type   = "COS"

    shielded_instance_config {
      enable_secure_boot = true
    }

    service_account = var.service_account_email

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

  }
  management {
    auto_repair  = true
    auto_upgrade = false
  }

}
