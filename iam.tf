data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      aws_secretsmanager_secret.secret.arn,
    ]
  }
}

resource "aws_iam_policy" "policy" {
  name   = "${local.prefix}-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.policy.json
}

data "aws_iam_policy_document" "assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "role" {
  name               = "${local.prefix}-role"
  description        = "${local.prefix}-role"
  assume_role_policy = data.aws_iam_policy_document.assume.json

  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.prefix}-role"
    },
  )
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "attach_policy2" {
  policy_arn = aws_iam_policy.policy.arn
  role       = aws_iam_role.role.name
}

resource "aws_iam_instance_profile" "profile" {
  name = "${local.prefix}-profile"
  role = aws_iam_role.role.name
}
