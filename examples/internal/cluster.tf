resource "aws_ecs_cluster" "example" {
  name = "${var.service}-${var.env}"

  tags = {
    Name = "${var.service}-${var.env}"
  }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  lifecycle {
    ignore_changes = [
      setting,
    ]
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.service}-${var.env}-ecs-task-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
  tags = {
    Name = "${var.service}-${var.env}-ecs-task-execution"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    sid     = "EcsAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

## SSM Decryption policy
resource "aws_iam_policy" "ecs_secrets_policy" {
  name        = "${var.service}-${var.env}-ecs-task-execution-ssm-policy"
  description = "Policy defining permissions for ECS to retrieve Secret and Parameter Store Values"
  policy      = data.aws_iam_policy_document.ecs_secrets_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_secrets_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_secrets_policy.arn
}

data "aws_iam_policy_document" "ecs_secrets_policy" {
  statement {
    sid    = "GetSecrets"
    effect = "Allow"

    actions = [
      "ssm:GetParameters",
      "secretsmanager:GetSecretValue",
      "kms:Decrypt",
    ]
    resources = [
      "arn:aws:ssm:${var.region}:*:parameter/*",
      "arn:aws:secretsmanager:${var.region}:*:secret:*",
      "arn:aws:kms:${var.region}:*:key/*"
    ]
  }
}
