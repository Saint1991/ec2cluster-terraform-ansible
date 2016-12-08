
# create route53 zone and register the domain of cluster instances
resource "aws_route53_zone" "routing_to_zone" {
  name = "${var.domain}"
}

# DNS name resolution for each instance
resource "aws_route53_record" "instance_a_records" {
  count = "${var.instance_count}"
  name = "${element(aws_instance.ec2_instance.*.tags.Name, count.index)}"
  type = "A"
  ttl = 300
  zone_id = "${aws_route53_zone.routing_to_zone.id}"
  records = ["${element(aws_instance.ec2_instance.*.public_ip, count.index)}"]
}

# DNS name resolution for load balancer
resource "aws_route53_record" "lb_a_record" {
  count = "${signum(var.instance_count)}"
  name = "${var.host_prefix}-${var.server_role}"
  type = "A"
  zone_id = "${aws_route53_zone.routing_to_zone.id}"
  alias {
    evaluate_target_health = true
    name = "${aws_elb.lb.dns_name}"
    zone_id = "${aws_elb.lb.zone_id}"
  }
}