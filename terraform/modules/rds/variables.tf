
variable "region" {}

variable "cluster_prefix" { }
variable "cluster_role" { default = "rds" }
variable "database_name" {}

variable "instance_count" { }
variable "instance_type" { default = "db.t2.medium" }
variable "port" { default = 3306 }

variable "master_user" { }
variable "master_pass" { }
variable "backup_retension_days" { default = 7 }

variable "domain" {}
