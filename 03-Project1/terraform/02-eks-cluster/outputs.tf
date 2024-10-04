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

output "oidc_provider_arn" {
  description = "AWS IAM Open ID Connect Provider ARN"
  value       = module.eks.oidc_provider_arn
}

output "oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
  value       = module.eks.oidc_provider
}