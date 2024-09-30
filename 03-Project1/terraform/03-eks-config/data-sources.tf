data "aws_caller_identity" "current" {}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks_cluster.outputs.cluster_name
}