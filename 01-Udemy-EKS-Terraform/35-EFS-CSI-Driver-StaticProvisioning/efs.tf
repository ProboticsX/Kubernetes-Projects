# Resource: EFS File System
resource "aws_efs_file_system" "efs_file_system" {
  creation_token = "efs-demo"
  tags = {
    Name = "efs-demo"
  }
}

# Resource: EFS Mount Target
resource "aws_efs_mount_target" "efs_mount_target" { # mount target is needed so that the pods can access the PVC, in our case PVC is needed by writer-pod and myapp-deployment pods
  #for_each = toset(module.vpc.private_subnets)
  count = 2
  file_system_id = aws_efs_file_system.efs_file_system.id
  subnet_id      = data.terraform_remote_state.eks.outputs.private_subnets[count.index]
  security_groups = [ aws_security_group.efs_allow_access.id ]
}