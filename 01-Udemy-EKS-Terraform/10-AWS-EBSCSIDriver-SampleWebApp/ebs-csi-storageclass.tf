# Resource: Kubernetes Storage Class
resource "kubernetes_storage_class_v1" "ebs_sc" {  
  metadata {
    name = "ebs-sc"
  }
  storage_provisioner = "ebs.csi.aws.com"
  volume_binding_mode = "WaitForFirstConsumer"
#   allow_volume_expansion = "true"  
#   reclaim_policy = "Retain" #Allows the persistant volume to remain even if the pvc gets deleted
}