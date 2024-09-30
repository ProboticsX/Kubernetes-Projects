# Resource: AWS IAM Role
resource "aws_iam_role" "admin_role" {
  name = "${local.resource_prefix}-admin-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      },
    ]
  })
  inline_policy {
    name = "${local.resource_prefix}-admin-policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = [
            "iam:ListRoles",
            "eks:*",
            "ssm:GetParameter"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }    
   tags = local.common_tags
}
resource "aws_iam_group_policy" "admin_policy" {
  name  = "${local.resource_prefix}-admin-policy"
  group = aws_iam_group.admin.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Sid    = "AllowAssumeOrganizationAccountRole"
        Resource = "${aws_iam_role.admin_role.arn}"
      },
    ]
  })
}

resource "aws_iam_group" "admin" {
  name = "${local.resource_prefix}-admins"
}

# Resource: AWS IAM User - Basic User (No AWSConsole Access)
resource "aws_iam_user" "admin_user" {
  name = "${local.resource_prefix}-admin"
  path = "/"
  force_destroy = true
  tags = local.common_tags
}


# Resource: AWS IAM Group Membership
resource "aws_iam_group_membership" "admin_membership" {
  name = "${local.resource_prefix}-admin-membership"
  users = [
    aws_iam_user.admin_user.name
  ]
  group = aws_iam_group.admin.name
}