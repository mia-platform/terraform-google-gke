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
}

module "gcp_gke_cluster" {
  source = "./modules/gcp_gke_cluster"

  cluster_name = var.cluster_name
  project_id   = var.project_id
  zone         = var.zone
  network      = var.network
  subnetwork   = var.subnetwork

  pods_ip_range                     = var.pods_ip_range
  services_ip_range                 = var.services_ip_range
  master_ip_range                   = var.master_ip_range
  master_authorized_networks_config = var.master_authorized_networks_config

  gke_version    = var.gke_version
  cluster_labels = var.cluster_labels
  security_group = var.security_group
}

module "gcp_gke_node_pool" {
  source = "./modules/gcp_gke_node_pool"

  project_id = var.project_id
  zone       = var.zone

  cluster_name = module.gcp_gke_cluster.cluster_name

  node_pools            = var.node_pools
  service_account_email = var.service_account_email
}
