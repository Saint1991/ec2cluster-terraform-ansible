
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.cluster_name}"
}

resource "aws_ecs_service" "ecs_service" {
  count = "${length(var.container_paths)}"
  name = "${element(keys(var.container_paths), count.index)}"
  cluster = "${aws_ecs_cluster.ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.ecs_tasks.arn}"
  desired_count = "${var.deploy_count}"

  load_balancer {
    elb_name = "${aws_ecs_cluster.ecs_cluster.name}"
    container_name = "${element(keys(var.container_paths), count.index)}"
    container_port = "${element(keys(var.port_mapping), count.index)}"
  }
}

resource "aws_ecs_task_definition" "ecs_tasks" {
  count = "${length(var.container_paths)}"
  container_definitions = "${element(data.template_file.container_definitions.*.rendered, count.index)}"
  family = "${element(keys(var.container_paths), count.index)}"
}

data "template_file" "container_definitions" {
  count = "${length(var.container_paths)}"
  template = "${file(element(values(var.container_paths), count.index))}"
  vars {
    image-name = "${element(keys(var.container_paths), count.index)}"
    internal_port = "${element(keys(var.port_mapping), count.index)}"
    external_port = "${element(values(var.port_mapping), count.index)}"
  }
}