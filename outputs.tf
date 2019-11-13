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

output "name" {
  value       = local.output_name
  description = "The name for the cluster"
}

output "location" {
  value       = local.output_location
  description = "The cluster location will be a region if regional cluster, or a zone if zonal cluster"
}

output "master_version" {
  description = "Current master kubernetes version"
  value       = local.output_master_version
}

output "endpoint" {
  value       = local.output_endpoint
  sensitive   = true
  description = "The cluster endpoint of the API Server"
  depends_on = [
    google_container_cluster.master,
    google_container_node_pool.pools,
  ]
}

output "instance_group_urls" {
  value       = local.output_instance_group_urls
  description = "List of instance group URLs which have been assigned to the cluster."
}

output "master_authorized_networks" {
  value       = local.output_master_authorized_networks
  description = "The authorized networks that can reach the API server"
}

output "ca_certificate" {
  value       = local.output_ca_certificate
  sensitive   = true
  description = "Cluster CA Certificate (base64 encoded)"
}
