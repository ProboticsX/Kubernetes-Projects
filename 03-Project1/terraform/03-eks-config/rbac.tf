# Resource: Cluster Role
resource "kubernetes_cluster_role_v1" "readonly_clusterrole" {
  metadata {
    name = "${local.resource_prefix}-readonly-clusterrole"
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "namespaces", "pods", "events", "services"]
    verbs      = ["get", "list"]    
  }
  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "daemonsets", "statefulsets", "replicasets"]
    verbs      = ["get", "list"]    
  }
  rule {
    api_groups = ["batch"]
    resources  = ["jobs"]
    verbs      = ["get", "list"]    
  }  
}

# Resource: Cluster Role Binding
resource "kubernetes_cluster_role_binding_v1" "readonly_clusterrolebinding" {
  metadata {
    name = "${local.resource_prefix}-readonly-clusterrolebinding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.readonly_clusterrole.metadata.0.name 
  }
  subject {
    kind      = "Group"
    name      = "shubhams-readonly-group"
    api_group = "rbac.authorization.k8s.io"
  }
}