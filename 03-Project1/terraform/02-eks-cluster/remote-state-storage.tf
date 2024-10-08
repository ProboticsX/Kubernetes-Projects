data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "4054-shubhams-dev"
    key    = "dev/eks/terraform.tfstate"
    region = var.aws_region
  }
}