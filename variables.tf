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

variable "cluster_name" {
  description = "The name for the cluster"
  type        = string
}

variable "project_id" {
  description = "The ID of the project where add this cluster"
  type        = string
}

variable "zone" {
  type        = string
  description = "Zone where create the cluster"
}

variable "network" {
  type        = string
  description = "Network self link"
}

variable "subnetwork" {
  type        = string
  description = "Subnetwork self link"
}

variable "pods_ip_range" {
  type        = string
  description = "Secondary range name for pods"
}

variable "services_ip_range" {
  type        = string
  description = "Secondary range name for services"
}

variable "master_ip_range" {
  type        = string
  description = "Ip range for master network ( CIDR notarion )"
}

variable "master_authorized_networks_config" {
  type        = list(object({ cidr_blocks = list(object({ cidr_block = string, display_name = string })) }))
  description = "The desired configuration options for master authorized networks. The object format is {cidr_blocks = list(object({cidr_block = string, display_name = string}))}. Omit the nested cidr_blocks attribute to disallow external access (except the cluster node IPs, which GKE automatically whitelists)."
  default     = []
}

variable "cluster_labels" {
  type        = map(string)
  description = "The GCP labels to attach on the GKE cluster"
  default     = {}
}

variable "node_pools" {
  type        = list(object({ name = string, node_count = number, machine_type = string, tags = list(string), labels = map(string) }))
  description = ""
}

variable "service_account_email" {
  type        = string
  description = "Service account email for the node pool"
}

variable "gke_version" {
  type        = string
  description = "Cluster version minimal"
}

variable "security_group" {
  type        = string
  description = "RBAC Security group"
}
