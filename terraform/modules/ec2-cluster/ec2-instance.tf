
# instance
resource "aws_instance" "ec2_instance" {
  depends_on = ["null_resource.init_inventory"]
  count = "${var.instance_count}"
  tags {
    Name = "${format("%s-%s%03d", var.host_prefix, var.server_role, count.index + 1)}"
  }
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.instance_keypair.key_name}"
  disable_api_termination = "${var.termination_disable}"
  instance_initiated_shutdown_behavior = "${var.shutdown_behavior}"
  monitoring = "${var.detailedly_monitoring}"
  iam_instance_profile = "${aws_iam_instance_profile.ec2_instance_iam_profile.name}"

  provisioner "file" {
    content = "${element(data.template_file.log_conf.*.rendered, count.index)}"
    destination = "/tmp/awslogs.cfg"
    connection {
      type = "ssh"
      user = "${var.ansible_ssh_user}"
      timeout = "1m"
      private_key = "${file(var.private_key)}"
    }
  }
}

