locals {
  name = "nginx"
}

data "aws_vpc" "coba_vpc" {
  filter {
    name   = "vpc-id"
    values = ["vpc-7d4fe117"]
  }
}

data "aws_subnet" "coba_subnet" {
  filter {
    name   = "subnet-id"
    values = ["subnet-0b5b5472"]
  }
}

module "nginx" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.2.0"

  name = "[gv2] ${local.name}"

  # Using Ubuntu 18.04 (arm64)
  ami                    = "ami-026141f3d5c6d2d0c"
  instance_type          = "t4g.micro"
  key_name               = "atlantis-key"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.nginx_security_group.id]
  subnet_id              = data.aws_subnet.coba_subnet.id

  root_block_device = [{
    volume_type           = "gp2"
    volume_size           = 10
    encrypted             = false
    delete_on_termination = false
  }]

  tags = {
    App       = "nginx"
    ManagedBy = "terraform"

  }
}

resource "aws_eip" "nginx" {
  instance = module.nginx.id
  vpc      = true
  tags     = {
    Name = "${local.name}-eip"
  }
}

resource "aws_security_group" "nginx_security_group" {
  name        = "nginx-security-group"
  description = "Security group for nginx instance"
  vpc_id      = data.aws_vpc.coba_vpc.id

  ingress = [
    {
      description      = "Allow HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "Allow All Outbound"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    App = "nginx"
    ManagedBy = "terraform"
  }
}
