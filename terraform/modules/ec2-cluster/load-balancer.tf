
resource "aws_elb" "lb" {
  depends_on = ["aws_instance.ec2_instance"]
  count = "${signum(var.instance_count)}"
  name = "${var.host_prefix}-${var.server_role}"
  availability_zones = ["${var.availability_zones[var.region]}"]
  access_logs {
    bucket = "${aws_s3_bucket.log_bucket.bucket}"
    bucket_prefix = "${var.log_bucket_prefix}/${var.server_role}"
    interval = 5
  }
  listener {
    instance_port = "${var.instance_port}"
    instance_protocol = "${var.lb_protocol}"
    lb_port = "${var.exposed_port}"
    lb_protocol = "${var.lb_protocol}"
  }
  health_check {
    healthy_threshold = "${var.healthy_threshold}"
    unhealthy_threshold = "${var.unhealthy_threshold}"
    interval = "${var.healthcheck_interval}"
    target = "${"${var.lb_protocol}:${var.instance_port}${var.healthcheck_path}"}"
    timeout = 10
  }
}

resource "aws_elb_attachment" "lb_attachment" {
  count = "${var.instance_count}"
  elb = "${aws_elb.lb.id}"
  instance = "${element(aws_instance.ec2_instance.*.id, count.index)}"
}