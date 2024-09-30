# Resource: AWS IAM Role
resource "aws_iam_role" "readonly_role" {
  name = "${local.resource_prefix}-readonly-role"
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
    name = "eks-readonly-access-policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = [
            "iam:ListRoles",
            "ssm:GetParameter",
            "eks:DescribeNodegroup",
            "eks:ListNodegroups",
            "eks:DescribeCluster",
            "eks:ListClusters",
            "eks:AccessKubernetesApi",
            "eks:ListUpdates",
            "eks:ListFargateProfiles",
            "eks:ListIdentityProviderConfigs",
            "eks:ListAddons",
            "eks:DescribeAddonVersions"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }    
    tags = local.common_tags
}

resource "aws_iam_group_policy" "readonly_policy" {
  name  = "${local.resource_prefix}-readonly-policy"
  group = aws_iam_group.readonly.name

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
        Resource = "${aws_iam_role.readonly_role.arn}"
      },
    ]
  })
}

resource "aws_iam_group" "readonly" {
  name = "${local.resource_prefix}-readonly"
}

# Resource: AWS IAM User - Basic User (No AWSConsole Access)
resource "aws_iam_user" "readonly_user" {
  name = "${local.resource_prefix}-readonly"
  path = "/"
  force_destroy = true
  tags = local.common_tags
}


# Resource: AWS IAM Group Membership
resource "aws_iam_group_membership" "readonly_membership" {
  name = "${local.resource_prefix}-readonly-membership"
  users = [
    aws_iam_user.readonly_user.name
  ]
  group = aws_iam_group.readonly.name
}