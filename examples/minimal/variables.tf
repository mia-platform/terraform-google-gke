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

variable "project_id" {
  type        = string
  description = "The ID of the GCE project where to add this cluster"
}

variable "location" {
  type        = string
  description = "The location where you want to create the cluster, must be a valid GCP region or zone"
}

variable "subnetwork_name" {
  type        = string
  description = "The GCP subnetwork name where you want to create your cluster, must be in the same project of the cluster"
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "Ip range for master network in CIDR notation"
}

variable "cluster_secondary_range_name" {
  type        = string
  description = "A GCP subnetwork secondary range name to use for the k8s pods"
}

variable "services_secondary_range_name" {
  type        = string
  description = "A GCP subnetwork secondary range name to use for the k8s services"
}

variable "master_authorized_network_cidr_block" {
  type        = string
  description = "The desired authorized network that can reach the API server"
}
