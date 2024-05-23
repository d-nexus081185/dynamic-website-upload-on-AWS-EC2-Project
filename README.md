This project shows the skill set gained in learing the foundations of 
1. Creating an EC2 instance in AWS; which invloves creating a keypair to enable SSH login to the EC2 instance.
2. Creating and configuring a security group to allow ingress port 22 [SSH] and 80 [http] which is required for apache2 installation and to allow SSH connections

Project steps:
1. I created an IAM user in the AWS console and gave it the following policy permissions:
AmazonEC2FullAccess - Full access to Amazon EC2 resources.
AmazonS3FullAccess - Full access to Amazon S3 buckets.
AmazonVPCFullAccess - Full access to Amazon VPC resources.
IAMFullAccess - Full access to IAM resources (optional, but necessary if Terraform needs to manage IAM roles, users, or policies).
CloudFrontFullAccess - Full access to CloudFront resources.
AmazonRoute53FullAccess - Full access to Route 53 resources.
CloudWatchFullAccess - Full access to CloudWatch resources.
AWSLambda_FullAccess - Full access to AWS Lambda resources.

2. I also created an access key for the IAM user to allow access to the AWS CLI using the AWS configure command.
This Access key was useful to establish Authentication for my Terraform resource/config.

3. I used Terraform [IAC] to created a yaml file main.tf and provider.tf using the harhicorp documention to create a resource block for the EC2 instance type with an Ubuntu image, Security group and allowed access to the default VPC instance.
Below is a sample of the Terraform code used:

Terraform main.tf 

resource "aws_instance" "Demo-Server" {
  ami                    = "ami-04b70fa74e45c3917"      #change ami id for different region
  instance_type          = "t2.micro"
  key_name               = "tf-key"              #change key name as per your setup
  vpc_security_group_ids = [aws_security_group.Demo-Server-SG.id]
  #user_data              = templatefile("./install.sh", {})

  tags = {
    Name = "Demo-Server"
  }

  root_block_device {
    volume_size = 30
  }
}

resource "aws_security_group" "Demo-Server-SG" {
  name        = "Demo-Server-SG"
  description = "Allow TLS inbound traffic"

  ingress = [
    for port in [22, 80 ] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Demo-Server-SG"
  }
}

output "Demo-Server_IP" {
  value = aws_instance.Demo-Server.public_ip
}

Terraform provider.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"     #change region as per you requirement
}
