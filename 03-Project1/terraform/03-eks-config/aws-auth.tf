locals {
  configmap_roles = [
    {
      rolearn = "${data.terraform_remote_state.eks_cluster.outputs.nodegroup_role_arn}"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    },
    {
      rolearn  = "${aws_iam_role.admin_role.arn}"
      username = "admin" # Can be any name
      groups   = ["system:masters"]
    },
    {
      rolearn  = "${aws_iam_role.readonly_role.arn}"
      username = "readonly"
      #groups   = [ "eks-readonly-group" ]
      # Important Note: The group name specified in clusterrolebinding and in aws-auth configmap groups should be same. 
      groups   = [ "${kubernetes_cluster_role_binding_v1.readonly_clusterrolebinding.subject[0].name}" ]
    }
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