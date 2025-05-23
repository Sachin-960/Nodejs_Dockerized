variable "region" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "key_pair_name" {}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Try to fetch existing security group
data "aws_security_group" "existing_sg" {
  name = "node-app-sg"
  # Optional: filter by VPC or tags if needed
}

# Create SG only if it doesn't exist
resource "aws_security_group" "new_sg" {
  count = length(data.aws_security_group.existing_sg.id) == 0 ? 1 : 0

  name        = "node-app-sg"
  description = "Allow SSH and HTTP for Node.js app"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Local value to reference correct SG
locals {
  sg_id = length(data.aws_security_group.existing_sg.id) > 0 ? data.aws_security_group.existing_sg.id : aws_security_group.new_sg[0].id
}

resource "aws_instance" "node_app_server" {
  ami           = "ami-0953476d60561c955" # Amazon Linux 
  instance_type = "t2.micro"

  key_name          = var.key_pair_name
  vpc_security_group_ids = [local.sg_id]

  tags = {
    Name = "NodeAppServer"
  }
}

output "public_ip" {
  value = aws_instance.node_app_server.public_ip
}