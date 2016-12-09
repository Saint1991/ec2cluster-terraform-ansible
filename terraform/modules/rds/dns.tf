
resource "aws_route53_zone" "routing_to_zone" {
  count = "${signum(var.instance_count)}"
  name = "${var.domain}"
}

# DNS name resolution to the cluster
resource "aws_route53_record" "cluster_cname_record" {
  count = "${signum(var.instance_count)}"
  name = "${var.cluster_prefix}-${var.cluster_role}"
  type = "CNAME"
  ttl = 300
  zone_id = "${aws_route53_zone.routing_to_zone.id}"
  records = ["${aws_rds_cluster.rds_cluster.endpoint}}"]
}

# DNS name resolution for each instance
resource "aws_route53_record" "instance_cname_record" {
  count = "${var.instance_count}"
  name = "${element(aws_rds_cluster_instance.rds_instance.*.identifier, count.index)}"
  type = "CNAME"
  ttl = 300
  zone_id = "${aws_route53_zone.routing_to_zone.id}"
  records = ["${element(aws_rds_cluster_instance.rds_instance.*.endpoint, count.index)}"]
}

