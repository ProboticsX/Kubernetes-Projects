resource "aws_iam_policy" "externaldns_iam_policy" {
  name        = "${local.resource_prefix}-AllowExternalDNSUpdates"
  path        = "/"
  description = "External DNS IAM Policy"
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
})
}



# Resource: Create IAM Role 
resource "aws_iam_role" "externaldns_iam_role" {
  name = "${local.resource_prefix}-externaldns-iam-role"

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
            "${data.terraform_remote_state.eks_cluster.outputs.oidc_provider_arn}:aud": "sts.amazonaws.com",            
            "${data.terraform_remote_state.eks_cluster.outputs.oidc_provider_arn}:sub": "system:serviceaccount:default:external-dns"
          }
        }        
      },
    ]
  })

  tags = {
    tag-key = "AllowExternalDNSUpdates"
  }
}

# Associate External DNS IAM Policy to IAM Role
resource "aws_iam_role_policy_attachment" "externaldns_iam_role_policy_attach" {
  policy_arn = aws_iam_policy.externaldns_iam_policy.arn 
  role       = aws_iam_role.externaldns_iam_role.name
}