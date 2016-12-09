
variable "cluster_name" {}
variable "repository_name" {}

variable "container_paths" { type = "map" }
variable "port_mapping" { type = "map" }

variable "deploy_count" {}

# required -> 1
# not required -> 0
variable "is_repository_required" { default = 0 }