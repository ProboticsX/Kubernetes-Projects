data "terraform_remote_state" "eks_cluster" {
  backend = "s3"
  config = {
    bucket = "4054-shubhams-dev"
    key    = "dev/eks-cluster/terraform.tfstate"
    region = var.aws_region
  }
}