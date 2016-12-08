
// for ansible
variable "ansible_path" { default = "$PWD/../../ansible"}
variable "inventory_path" { default = "$PWD/../../ansible/aws/inventory"}
variable "ansible_ssh_user" { default = "ec2-user" }

// account
variable "account_id" {}

// ssh key
variable "public_key" {}
variable "private_key" {}
variable "keypair_name" {}

variable "region" {}

variable "shutdown_behavior" { default = "stop" }
variable "volume_force_detach" { default = false }
variable "bucket_force_destroy" { default = false }
variable "termination_disable" { default = true }


// for naming servers
variable "host_prefix" {}
variable "server_role" {}
variable "domain" {}

// params for instance spec
variable "ami" {}
variable "instance_type" {}
variable "instance_count" {}

variable "volume_type" {}
variable "volume_size" {}
variable "raid_factor" {}
variable "raid_level" { default = 0 } // 0 or 1 is recommended
variable "raid_mount_dir" {}

// for monitoring
variable "detailedly_monitoring" { default = true }

// for logging
variable "log_bucket" {}
variable "log_bucket_prefix" {}
variable "log_retention_days" { default = 7 }
variable "log_paths" {
  type = "map"
  default = {
    messages = "/var/log/messages"
  }
}
variable "log_datetime_format" { default = "%b %d %H:%M:%S" }


// for alert
variable "alert_rules" {
  type = "map"
  default = {
    CPUUtilization = 80
  }
}
variable "alert_statistics" { default = "Average" }

// for load balancer
variable "instance_port" {} // service port for each instance
variable "exposed_port" {} // exposed port on load balancer
variable "lb_protocol" { default = "HTTP" }

// for health checking
variable "healthcheck_path" { default = "" }
variable "healthy_threshold" { default = 2 }
variable "unhealthy_threshold" { default = 2 }
variable "healthcheck_interval" { default = 20 }

// testing with serverspec (required => 1, not required => 0)
variable "is_test_required" { default = 1 }