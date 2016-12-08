
// create volumes
resource "aws_ebs_volume" "volume" {
  count = "${var.instance_count * var.raid_factor}"
  tags {
    Name = "${format("%s-%s%03d-raid%03d", var.host_prefix, var.server_role, count.index / var.raid_factor + 1, count.index % var.raid_factor + 1)}"
  }
  #availability_zone = "${element(var.availability_zones[var.region], count.index % length(var.availability_zones[var.region]))}"
  availability_zone = "${element(aws_instance.ec2_instance.*.availability_zone, count.index / var.raid_factor)}"
  size = "${var.volume_size}"
  type = "${var.volume_type}"
}

// atatch volumes to ec2-instances
resource "aws_volume_attachment" "volume_attachment" {
  count = "${var.instance_count * var.raid_factor}"
  device_name = "${format("/dev/sd%s", element(var.device_alphabets, count.index % var.raid_factor))}"
  instance_id = "${element(aws_instance.ec2_instance.*.id, count.index / var.raid_factor)}"
  volume_id = "${element(aws_ebs_volume.volume.*.id, count.index)}"
  force_detach = "${var.volume_force_detach}"
}

// raid
resource "null_resource" "raid" {
  depends_on = ["aws_volume_attachment.volume_attachment"]
  count = "${var.instance_count}"
  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y mdadm xfsprogs",
      "DEVS=(`ls -l /dev | grep sd[b-z] | awk '{print $9}'`)",
      "DEVICES=()",
      "for dev in $${DEVS[@]}; do DEVICES+=( \"/dev/$$dev\" ); done",
      "sudo mdadm --create --verbose /dev/md/md0 --level=${var.raid_level} --name=0 --raid-devices $${#DEVICES[*]} $${DEVICES[@]}",
      "sudo mkfs.xfs -L MYRAID /dev/md/md0",
      "sudo mkdir -p ${var.raid_mount_dir}",
      "sudo mount LABEL=MYRAID ${var.raid_mount_dir}"
    ]
    connection {
      type = "ssh"
      user = "${var.ansible_ssh_user}"
      host = "${element(aws_instance.ec2_instance.*.public_ip, count.index)}"
      timeout = "1m"
      private_key = "${file(var.private_key)}"
    }
  }
}