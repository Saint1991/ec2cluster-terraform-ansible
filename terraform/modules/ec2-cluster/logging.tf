
# Logging
resource "aws_cloudwatch_log_group" "log_group" {
  count = "${signum(var.instance_count)}"
  name = "${var.host_prefix}-${var.server_role}"
  retention_in_days = "${var.log_retention_days}"
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  count = "${var.instance_count * length(var.log_paths)}"
  log_group_name = "${aws_cloudwatch_log_group.log_group.name}"
  name = "${format("%s-%s%03d", var.host_prefix, element(keys(var.log_paths), count.index % length(var.log_paths)), count.index / length(var.log_paths) + 1)}"
}



data "template_file" "log_conf" {
  count = "${var.instance_count}"
  template = "${file("${path.module}/files/awslogs.cfg")}"
  vars {
    log_confs = "${join("\n\n", formatlist("[%s]\nfile = %s\nlog_group_name = %s\nlog_stream_name = %s\ndatatime_format = %s",
      keys(var.log_paths),
      values(var.log_paths),
      aws_cloudwatch_log_group.log_group.name,
      formatlist("%s-%s%03d", var.host_prefix, keys(var.log_paths), count.index + 1),
      var.log_datetime_format
    ))}"
  }
}


# a bucket to put logs
resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.log_bucket}"
  force_destroy = "${var.bucket_force_destroy}"
  acl = "private"
}

resource "aws_s3_bucket_policy" "log_bucket_policy" {
  bucket = "${aws_s3_bucket.log_bucket.bucket}"
  policy = "${data.aws_iam_policy_document.log_bucket_policy_document.json}"
}

data "aws_iam_policy_document" "log_bucket_policy_document" {
  statement {
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${var.log_bucket}/${var.log_bucket_prefix}/${var.server_role}/AWSLogs/${var.account_id}/*"
    ]
    principals {
      identifiers = ["${lookup(var.elb_principals, var.region)}"]
      type = "AWS"
    }
  }
}






