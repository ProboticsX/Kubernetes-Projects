# Get AWS Account ID
data "aws_caller_identity" "current" {}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

# Locals Block
locals {
  configmap_roles = [
    { rolearn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/hr-dev-eks-nodegroup-role" # hard-coded for now because I don't want to create the cluster again
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    },  
    {
      rolearn  = "${aws_iam_role.eks_readonly_role.arn}"
      username = "eks-readonly" # Just a place holder name
      #groups   = [ "eks-readonly-group" ]
      # Important Note: The group name specified in clusterrolebinding and in aws-auth configmap groups should be same. 
      groups   = [ "${kubernetes_cluster_role_binding_v1.eksreadonly_clusterrolebinding.subject[0].name}" ]
    },     
  ]
}

resource "kubernetes_config_map_v1" "aws_auth" {
  depends_on = [
    kubernetes_cluster_role_binding_v1.eksreadonly_clusterrolebinding
      ]
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = yamlencode(local.configmap_roles)
  }  
}