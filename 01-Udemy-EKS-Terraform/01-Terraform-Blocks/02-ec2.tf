resource "aws_instance" "shubhams_ec2" {
  ami = "ami-04b70fa74e45c3917"
  instance_type = "t3.micro"
  user_data = file("${path.module}/app1-install.sh")
  subnet_id     = aws_subnet.example.id
}

resource "aws_vpc" "example" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "example" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "tf-example"
  }
}