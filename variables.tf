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

variable "name" {
  type        = string
  description = "The name for the cluster"
}

variable "description" {
  type        = string
  default     = ""
  description = "A description to add to the cluster"
}

variable "project_id" {
  type        = string
  description = "The ID of the GCE project where to add this cluster"
}

variable "kubernetes_version" {
  type        = string
  default     = "latest"
  description = "The Kubernetes master version, If set to 'latest' it will pull latest available version in the selected region."
}

variable "location" {
  type        = string
  description = "The location where you want to create the cluster, must be a valid GCP region or zone. The default value will create a regional cluster."
  default     = "europe-west1"
}

variable "zones" {
  type        = list(any)
  default     = []
  description = "If you are creating a regional or multizonal cluster, set here the desired zone names"
}

variable "subnetwork" {
  type        = string
  description = "The GCP subnetwork self_link where you want to create your cluster"
}

variable "enable_private_only_api_server" {
  type        = bool
  default     = true
  description = "Set to false to enable public endpoint for the Api Server"
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

variable "master_authorized_networks" {
  type        = list(object({ cidr_block = string, display_name = string }))
  description = "The desired authorized networks that can reach the API server"
}

variable "master_global_access" {
  type        = bool
  default     = true
  description = "Whether the cluster master is accessible globally or only from the same region."
}

variable "authenticator_security_group" {
  type        = string
  default     = ""
  description = "The name of the RBAC security group for use with Google security groups in Kubernetes RBAC. Group name must be in format gke-security-groups@yourdomain.com"
}

variable "vertical_pod_autoscaling_enabled" {
  type        = bool
  default     = false
  description = "Enable the vertical pod autoscaling functionality of the GKE cluster"
}

variable "gke_calico_enabled" {
  type        = bool
  default     = true
  description = "Enable the GKE managed Calico installation for Network Policies"
}

variable "enable_pod_security_policies" {
  type        = bool
  default     = true
  description = "Enable Pod Security Policy in cluster"
}

variable "csi_driver_enabled" {
  type        = bool
  default     = false
  description = "Enable new CSI Persistent Volume controller"
}

variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Enable the deletion protection for avoiding to accidentally delete the cluster with terraform destroy"
}

variable "defaults_node_pools_configs" {
  type        = map(string) # Check the README for the valid properties for this object
  default     = {}
  description = "Default values to apply to all the node pools"
}

variable "defaults_node_pools_tags" {
  type        = list(string)
  default     = []
  description = "A default set of tags to apply to all the node_pools instances"
}

variable "defaults_node_pools_labels" {
  type        = map(string)
  default     = {}
  description = "A default set of labels to apply to all the node_pools instances"
}

variable "node_pools" {
  type        = list(map(string)) # Check the README for the valid properties for the object contained in the array
  default     = []
  description = "An object list defining node pools configurations"
}

variable "node_pools_tags" {
  type        = map(list(string))
  default     = {}
  description = "The tags list to apply to the node_pools, use the node_pools name as key of the map"
}

variable "node_pools_labels" {
  type        = map(map(string))
  default     = {}
  description = "The lables to apply to the node_pools, use the node_pools name as key of the map"
}

variable "node_pools_taints" {
  type        = map(list(map(string)))
  default     = {}
  description = "The taints to apply to the node_pools, use the node_pools name as key of the map"
}

variable "maintenance_start_time" {
  type        = string
  description = "Time window specified for daily maintenance operations in RFC3339 format"
  default     = "01:00"
}

variable "maintenance_exclusion_start_time" {
  type        = string
  description = "Time window specified for excluding any maintenance operations in ISO 8601 format"
  default     = null
}

variable "maintenance_exclusion_end_time" {
  type        = string
  description = "Time window specified for excluding any maintenance operations in ISO 8601 format"
  default     = null
}

variable "maintenance_scope" {
  type        = string
  description = "Maintenance scope: it default to no minor upgrades"
  default     = "NO_MINOR_UPGRADES"
}

variable "labels" {
  type        = map(string)
  description = "The GCP labels to attach on the GKE cluster"
  default     = {}
}

variable "enable_shielded_nodes" {
  type        = bool
  default     = true
  description = "The flag that enables shielded nodes"
}

variable "cluster_release_channel" {
  type        = string
  default     = "UNSPECIFIED"
  description = "GKE Upgrade release channel"
}

variable "autoupgrade_settings" {
  type = object({
    enabled                 = optional(string, false),
    strategy                = optional(string,"SURGE")
    batch_node_count        = optional(number,1)
    batch_soak_duration     = optional(string, "300s")
    node_pool_soak_duration = optional(string,"3600s")
  })
  default     = {}
  description = "GKE Auto upgrade settings"
}
