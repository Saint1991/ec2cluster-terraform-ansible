

resource "null_resource" "init_inventory" {
  count = "${signum(var.instance_count)}"
  provisioner "local-exec" {
    command = "rm -f ${var.inventory_path}"
  }
}

# create inventory for ansible
resource "null_resource" "create_inventory" {
  depends_on = ["null_resource.init_inventory"]
  count = "${signum(var.instance_count)}"
  provisioner  "local-exec" {
    command = "echo \"\n[${var.server_role}]\n${join("\n", formatlist("%s ansible_ssh_user=%s ansible_ssh_private_key_file=%s", aws_instance.ec2_instance.*.public_ip, var.ansible_ssh_user, var.private_key))}\" >> ${var.inventory_path}"
  }
}

# execute Ansible provisioning
resource "null_resource" "ansible-provisioning" {
  count = "${signum(var.instance_count)}"
  depends_on = [
    "aws_instance.ec2_instance",
    "null_resource.create_inventory"
  ]
  provisioner "local-exec" {
    command = "ansible-playbook -i ${var.inventory_path} ${var.ansible_path}/site.yml"
  }
}


resource "null_resource" "ansible-spec" {
  count = "${signum(var.is_test_required) * signum(var.instance_count)}"
  depends_on = ["null_resource.ansible-provisioning"]
  provisioner "local-exec" {
    command = "cd ${var.ansible_path} && rake all"
  }
}