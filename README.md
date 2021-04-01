# Terraform GCP Project

A Terraform module for GKE Cluster with opinionated options, we focus on getting the most of the security feature
available turned on, and with minimal dependencies to gke managed feature if not necessary.

## Compatibility

This module is meant for use with Terraform 0.12.

## Requirements

### Software

- [Terraform][terraform] >= 0.12.6
- [terraform-provider-google-beta][provider-google-beta] plugin >= 3.22 <4.0.0

### Permissions

In order to execute this module you must start the Google providers with a Service Account
with at least the following roles:

- `roles/compute.viewer`
- `roles/compute.securityAdmin`
- `roles/container.clusterAdmin`
- `roles/container.developer`
- `roles/iam.serviceAccountUser`

## `node_pools` and `defaults_node_pools_configs` variables

The node_pools variable takes the following parameters:

| Name | Description | Type | Default | `defaults_node_pools_configs` | Requirement |
| --- | --- |:---:|:---:|:---:|:---:|
| name | The name of the pool | string |  | ❌ | Required |
| min_size | The minumun number of nodes in the pool | number | 3 | ✅ | Optional |
| max_size | The minumun number of nodes in the pool, if not present the same value of `min_size` will be used | number | `min_size` | ✅ | Optional |
| machine_type | The GCP instance machine type to use | string |  | ✅ | Required |
| machine_image | The GCP instance machine image name to use | string | `"COS"` | ✅ | Optional |
| min_cpu_platform | The minimum CPU platform to use, if not set the zone default will be used | string | `""` | ✅ | Optional |
| disk_size_gb | The root disk size of the nodes, expressed in GB. The minimum value is `10` | number | `50` | ✅ | Optional |
| service_account | The service account to be used by the Node VMs | string | `""` | ✅ | Optional |
| node_locations | A comma separated list of zone location for the pool | string | `""` | ❌ | Optional |

## Contributing

Please read [CONTRIBUTING.md](/CONTRIBUTING.md) for details on our code of conduct,
and the process for submitting pull requests to us.

## Versioning

We use [SemVer][semver] for versioning. For the versions available,
see the [tags on this repository](https://github.com/mia-platform/terraform-google-project/tags).

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE.md](/LICENSE.md)
file for details

[terraform]: https://www.terraform.io/downloads.html (Terraform enables you to safely and predictably create, change, and improve infrastructure.)
[provider-google-beta]: https://github.com/terraform-providers/terraform-provider-google-beta
[semver]: http://semver.org/ (Semantic Versioning spec and website)
