data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "4054-shubhams-eks"
    key    = "dev/vpc/terraform.tfstate"
    region = var.aws_region
  }
}