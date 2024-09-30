data "aws_vpc" "vpc_data" {
  id = data.terraform_remote_state.eks.outputs.vpc_id
}