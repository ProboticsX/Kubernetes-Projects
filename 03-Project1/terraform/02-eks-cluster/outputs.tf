# EKS Cluster Outputs
output "cluster_name" {
  description = "The name/id of the EKS cluster."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "The cluster endpoint of the EKS cluster."
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "The cluster certificate authority data of the EKS cluster."
  value = module.eks.cluster_certificate_authority_data
}

output "nodegroup_role_arn" {
  description = "Nodegroup IAM role ARN"
  value = aws_iam_role.nodegroup_role.arn
}