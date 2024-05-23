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
