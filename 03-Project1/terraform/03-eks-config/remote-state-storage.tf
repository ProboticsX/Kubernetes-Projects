data "terraform_remote_state" "eks_cluster" {
  backend = "s3"
  config = {
    bucket = "4054-shubhams-eks"
    key    = "dev/eks-cluster/terraform.tfstate"
    region = var.aws_region
  }
}