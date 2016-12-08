
resource "aws_key_pair" "instance_keypair" {
  key_name = "${var.keypair_name}"
  public_key = "${file("${var.public_key}")}"
}

resource "aws_iam_instance_profile" "ec2_instance_iam_profile" {
  name = "logging-instance-profile"
  roles = ["${aws_iam_role.logging_role.name}"]
}



data "aws_iam_policy_document" "assume_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type = "Service"
    }
  }
}

// IAM policy for logging
data "aws_iam_policy_document" "logging_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}


resource "aws_iam_role" "logging_role" {
  name = "logging"
  assume_role_policy = "${data.aws_iam_policy_document.assume_policy_document.json}"
}

resource "aws_iam_role_policy" "logging_policy" {
  name = "logging-role-policy"
  policy = "${data.aws_iam_policy_document.logging_policy.json}"
  role = "${aws_iam_role.logging_role.id}"
}