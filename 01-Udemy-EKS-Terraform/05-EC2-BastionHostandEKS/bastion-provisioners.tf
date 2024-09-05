resource "null_resource" "copy_ec2_keys" {
  depends_on = [module.ec2_public]
  connection {
    type        = "ssh"
    host        = aws_eip.bastion_eip.public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("private-keys/eks-terraform-key.pem")
  }
  # copies key from local machine to the ec2 host - Failing because file provisioner doesn't have permissions to copy to remote host
#   provisioner "file" {
#     source      = "private-keys/eks-terraform-key.pem"
#     destination = "/tmp/eks-terraform-key.pem"
#   }

  # execute the chmod command on the ec2 host
  provisioner "remote-exec" {
    inline = [
        "sudo mv private-keys/eks-terraform-key.pem /tmp/eks-terraform-key.pem",
        "sudo chmod 400 /tmp/eks-terraform-key.pem"
    ]
  }

  # executed during creation or destroy time of the resource
  provisioner "local-exec" {
    command     = "echo VPC created on `date` and VPC ID: ${module.vpc.vpc_id} >> creation-time-vpc-id.txt"
    working_dir = "local-exec-output-files/"
    #on_failure = continue
  }
}