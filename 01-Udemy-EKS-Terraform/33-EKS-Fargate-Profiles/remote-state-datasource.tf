data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "terraform-on-aws-eks-shubhams"
    key    = "dev/eks-cluster/terraform.tfstate"
    region = var.aws_region
  }
}