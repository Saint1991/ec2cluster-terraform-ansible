

resource "aws_cloudwatch_metric_alarm" "alert" {
  count = "${var.instance_count * length(var.alert_rules)}"
  alarm_name = "${element(aws_instance.ec2_instance.*.tags.Name, count.index / length(var.alert_rules))}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name = "${element(keys(var.alert_rules), count.index % length(var.alert_rules))}"
  threshold = "${element(values(var.alert_rules), count.index % length(var.alert_rules))}"
  namespace = "AWS/EC2"
  evaluation_periods = 10
  period = 60
  statistic = "${var.alert_statistics}"
  dimensions {
    InstanceId = "${element(aws_instance.ec2_instance.*.id, count.index / length(var.alert_rules))}"
  }
  # alarm_actions = [] FIXME set the actions when alert is fired
}