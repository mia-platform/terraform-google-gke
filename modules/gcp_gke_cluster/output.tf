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

output "endpoint" {
  value       = google_container_cluster.cluster.endpoint
  description = "The IP address of this cluster's Kubernetes master"
}

output "instance_group_urls" {
  value       = google_container_cluster.cluster.instance_group_urls
  description = "List of instance group URLs which have been assigned to the cluster"
}

output "client_certificate" {
  value       = google_container_cluster.cluster.master_auth.0.client_certificate
  description = "Base64 encoded public certificate used by clients to authenticate to the cluster endpoint"
}

output "client_key" {
  value       = google_container_cluster.cluster.master_auth.0.client_key
  description = "Base64 encoded private key used by clients to authenticate to the cluster endpoint"
}

output "cluster_ca_certificate" {
  value       = google_container_cluster.cluster.master_auth.0.cluster_ca_certificate
  description = "Base64 encoded public certificate that is the root of trust for the cluster"
}

output "master_version" {
  value       = google_container_cluster.cluster.master_version
  description = "The current version of the master in the cluster. This may be different than the min_master_version set in the config if the master has been updated by GKE"
}

output "cluster_name" {
  value       = google_container_cluster.cluster.name
  description = "Cluster Name"
}
