resource "aws_iam_policy" "ebs_csi_iam_policy" {
  name        = "${local.resource_prefix}-AmazonEKS_EBS_CSI_Driver_Policy"
  path        = "/"
  description = "EBS CSI IAM Policy"
  policy      = data.http.ebs_csi_iam_policy.response_body
  tags = local.common_tags
}


resource "aws_iam_role" "ebs_csi_iam_role" {
  name = "${local.resource_prefix}-ebs-csi-iam-role"

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
            "${data.terraform_remote_state.eks_cluster.outputs.oidc_provider}:sub" : "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }

      },
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "ebs_csi_iam_role_policy_attach" {
  policy_arn = aws_iam_policy.ebs_csi_iam_policy.arn
  role       = aws_iam_role.ebs_csi_iam_role.name
}

