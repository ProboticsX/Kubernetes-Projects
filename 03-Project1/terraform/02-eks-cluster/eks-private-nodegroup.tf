resource "aws_eks_node_group" "private_node_group" {
  cluster_name    = module.eks.cluster_name
  node_group_name = "${local.resource_prefix}-private-node-group"
  node_role_arn   = aws_iam_role.nodegroup_role.arn
  subnet_ids      = data.terraform_remote_state.eks.outputs.private_subnets


  ami_type       = "AL2023_ARM_64_STANDARD"
  capacity_type  = "ON_DEMAND"
  disk_size      = 20
  instance_types = ["r6g.2xlarge","r6g.xlarge"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = local.common_tags
}