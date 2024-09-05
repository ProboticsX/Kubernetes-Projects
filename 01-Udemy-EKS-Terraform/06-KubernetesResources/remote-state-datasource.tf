data "terraform_remote_state" "eks"{
    backend = "local"
    config = {
      path = "../05-EC2-BastionHostandEKS/terraform.tfstate"
    }
}