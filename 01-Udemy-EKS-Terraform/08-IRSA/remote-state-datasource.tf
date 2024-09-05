# data "terraform_remote_state" "eks"{
#     backend = "local"
#     config = {
#       path = "../05-EC2-BastionHostandEKS/terraform.tfstate"
#     }
# }

# Using the other project's output tfstate values
data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "terraform-on-aws-eks-shubhams"
    key    = "dev/eks-cluster/terraform.tfstate"
    region = var.aws_region
  }
}