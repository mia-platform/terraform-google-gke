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

provider "google" {
  version = "~> 3.22.0"
}

data "google_compute_subnetwork" "subnetwork" {
  project = var.project_id
  name    = var.subnetwork_name
}

module "gke" {
  source = "../../"

  name       = "minimal-cluster"
  project_id = var.project_id
  location   = var.location

  subnetwork = data.google_compute_subnetwork.subnetwork.self_link

  master_ipv4_cidr_block        = var.master_ipv4_cidr_block
  cluster_secondary_range_name  = var.cluster_secondary_range_name
  services_secondary_range_name = var.services_secondary_range_name

  master_authorized_networks = [
    {
      cidr_block   = var.master_authorized_network_cidr_block
      display_name = "DMZ"
    },
  ]

  node_pools = [
    {
      name         = "pool"
      machine_type = "n1-standard1"
    },
  ]
}

data "google_client_config" "default" {
}
