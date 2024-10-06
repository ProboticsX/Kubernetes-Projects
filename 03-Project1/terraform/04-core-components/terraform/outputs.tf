output "externaldns_iam_policy_arn" {
  value = aws_iam_policy.externaldns_iam_policy.arn 
}

output "externaldns_iam_role_arn" {
  description = "External DNS IAM Role ARN"
  value = aws_iam_role.externaldns_iam_role.arn
}

output "efs_csi_iam_policy_arn" {
  value = aws_iam_policy.efs_csi_iam_policy.arn 
}

output "efs_csi_iam_role_arn" {
  description = "EFS CSI IAM Role ARN"
  value = aws_iam_role.efs_csi_iam_role.arn
}

output "lbc_iam_policy" {
  value = data.http.lbc_iam_policy.response_body
}

output "efs_csi_iam_policy" {
  value = data.http.efs_csi_iam_policy.response_body
}