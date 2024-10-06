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

# Resource: Security Group - Allow Inbound NFS Traffic from EKS VPC CIDR to EFS File System
resource "aws_security_group" "efs_allow_access" {
  name        = "${local.resource_prefix}-efs-allow-nfs-from-eks-vpc"
  description = "Allow Inbound NFS Traffic from EKS VPC CIDR"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description      = "Allow Inbound NFS Traffic from EKS VPC CIDR to EFS File System"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks      = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}


# Resource: EFS File System
resource "aws_efs_file_system" "efs_file_system" {
  creation_token = "efs-demo"
  tags = merge(local.common_tags, {
    Name = "efs-demo"
  })
}

# Resource: EFS Mount Target
resource "aws_efs_mount_target" "efs_mount_target" { # mount target is needed so that the pods can access the PVC
  count = 2
  file_system_id = aws_efs_file_system.efs_file_system.id
  subnet_id      = data.terraform_remote_state.vpc.outputs.private_subnets[count.index]
  security_groups = [ aws_security_group.efs_allow_access.id ]
}