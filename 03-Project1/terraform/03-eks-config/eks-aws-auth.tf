locals {
  configmap_roles = [
    {
      rolearn = "${data.terraform_remote_state.eks_cluster.outputs.nodegroup_role_arn}"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    },
    {
      rolearn  = "${aws_iam_role.admin_role.arn}"
      username = "eks-admin" # Can be any name
      groups   = ["system:masters"]
    },
  ]
}

resource "kubernetes_config_map_v1_data" "aws_auth" {
  force = true
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = yamlencode(local.configmap_roles)
  }  
}