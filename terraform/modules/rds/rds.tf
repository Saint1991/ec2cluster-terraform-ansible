
resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier = "${var.cluster_prefix}-${var.cluster_role}"
  database_name = "${var.database_name}"
  master_username = "${var.master_user}"
  master_password = "${var.master_pass}"
  final_snapshot_identifier = "${var.cluster_prefix}-${var.cluster_role}-snapshot"
  availability_zones = ["${var.availability_zones[var.region]}"]
  backup_retention_period = "${var.backup_retension_days}"
  port = "${var.port}"
}

resource "aws_rds_cluster_instance" "rds_instance" {
  cluster_identifier = "${aws_rds_cluster.rds_cluster.id}"
  count = "${var.instance_count}"
  identifier = "${format("%s-%s-%03d", var.cluster_prefix, var.cluster_role, count.index + 1)}"
  instance_class = "${var.instance_type}"
  tags {
    Name = "${format("%s-%s-%03d", var.cluster_prefix, var.cluster_role, count.index + 1)}"
  }
}

resource "aws_rds_cluster_parameter_group" "rds_config" {

  name = "rds-server-config-${var.cluster_role}-${var.cluster_prefix}"
  family = "aurora5.6"
  description = "RDS configuration"

  parameter {
    name = "character_set_server"
    value = "utf8"
  }

  parameter {
    name = "character_set_client"
    value = "utf8"
  }
}
