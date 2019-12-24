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

variable "project_id" {
  description = "The ID of the project where add this cluster"
  type        = string
}

variable "zone" {
  type        = string
  description = "Zone where create the cluster"
}

variable "service_account_email" {
  type        = string
  description = "Service account email for the node pool"
}

variable "cluster_name" {
  type        = string
  description = "Cluser name of the cluster where create the node pool"
}

variable "node_pools" {
  type        = list(object({ name = string, node_count = number, machine_type = string, tags = list(string), labels = map(string) }))
  description = ""
}
