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

locals {
  min_master_version           = var.kubernetes_version != "latest" ? var.kubernetes_version : data.google_container_engine_versions.available.latest_master_version
  authenticator_security_group = var.authenticator_security_group == null ? {} : { security_group = var.authenticator_security_group }
  workload_identity_namespace  = "${var.project_id}.svc.id.goog"
  master_authorized_networks_config = length(var.master_authorized_networks) == 0 ? [] : [{
    cidr_blocks : var.master_authorized_networks
  }]

  defaults_node_pools_configs = merge({
    min_size         = 3
    min_cpu_platform = ""
    disk_size_gb     = 50
    service_account  = ""
    machine_image    = "COS"
  }, var.defaults_node_pools_configs)
  node_pool_names = [for pool in var.node_pools : pool.name]
  node_pools = { for pool in var.node_pools :
    pool.name => merge(local.defaults_node_pools_configs, pool)
  }

  output_name                       = google_container_cluster.master.name
  output_location                   = google_container_cluster.master.location
  output_master_version             = google_container_cluster.master.master_version
  output_endpoint                   = google_container_cluster.master.endpoint
  output_master_authorized_networks = google_container_cluster.master.master_authorized_networks_config
  output_ca_certificate             = google_container_cluster.master.master_auth.0.cluster_ca_certificate
  output_instance_group_urls        = google_container_cluster.master.instance_group_urls
}

data "google_project" "prj" {
  project_id = var.project_id
}

data "google_container_engine_versions" "available" {
  location = var.location
  project  = data.google_project.prj.project_id
}

data "google_compute_subnetwork" "subnetwork" {
  self_link = var.subnetwork
}
