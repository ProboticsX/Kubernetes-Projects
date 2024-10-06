# Resource: Create IAM Role and associate the EFS IAM Policy to it
resource "aws_iam_role" "efs_csi_iam_role" {
  name = "${local.resource_prefix}-efs-csi-iam-role"

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
            "${data.terraform_remote_state.eks_cluster.outputs.oidc_provider}:sub": "system:serviceaccount:kube-system:efs-csi-controller-sa"
          }
        }        
      },
    ]
  })

  tags = local.common_tags
}

# Resource: Create EFS CSI IAM Policy 
resource "aws_iam_policy" "efs_csi_iam_policy" {
  name        = "${local.resource_prefix}-AmazonEKS_EFS_CSI_Driver_Policy"
  path        = "/"
  description = "EFS CSI IAM Policy"
  #policy = data.http.efs_csi_iam_policy.body
  policy = data.http.efs_csi_iam_policy.response_body
  tags = local.common_tags
}

# Associate EFS CSI IAM Policy to EFS CSI IAM Role
resource "aws_iam_role_policy_attachment" "efs_csi_iam_role_policy_attach" {
  policy_arn = aws_iam_policy.efs_csi_iam_policy.arn 
  role       = aws_iam_role.efs_csi_iam_role.name
}
