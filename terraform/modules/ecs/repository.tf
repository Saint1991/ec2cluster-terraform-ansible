
resource "aws_ecr_repository" "private_repository" {
  count = "${signum(var.is_repository_required)}"
  name = "${var.repository_name}"
}

resource "aws_ecr_repository_policy" "docker_repo_policy" {
  count = "${signum(var.is_repository_required)}"
  repository = "${aws_ecr_repository.private_repository.name}"
  policy = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "new policy",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        }
    ]
  }
EOF
}