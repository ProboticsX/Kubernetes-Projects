resource "aws_iam_policy" "s3_iam_policy" {
  name        = "${local.resource_prefix}-S3_IAM_Policy"
  path        = "/"
  description = "S3 IAM Policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${local.resource_prefix}-eks",  # Replace with your S3 bucket name
          "arn:aws:s3:::${local.resource_prefix}-eks/*"  # Allow access to objects within the bucket
        ]
      }
    ]
  })
  tags = local.common_tags
}


resource "aws_iam_role" "s3_iam_role" {
  name = "${local.resource_prefix}-s3-iam-role"

  # Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "${data.terraform_remote_state.eks_cluster.outputs.oidc_provider_arn}"
        }
        Condition = {
          StringEquals = {
            "${data.terraform_remote_state.eks_cluster.outputs.oidc_provider}:sub" : "system:serviceaccount:default:images-sa"
          }
        }

      },
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "s3_iam_role_policy_attach" {
  policy_arn = aws_iam_policy.s3_iam_policy.arn
  role       = aws_iam_role.s3_iam_role.name
}

