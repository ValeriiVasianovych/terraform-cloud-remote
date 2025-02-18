resource "aws_security_group" "webserver-sg" {
  vpc_id = module.vpc.vpc_id
  name   = "webserver-sg"

  dynamic "ingress" {
    for_each = [22, 80, 443]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "webserver_eip" {}

resource "aws_instance" "web-server" {
  ami                         = data.aws_ami.latest_ubuntu.id
  instance_type               = local.instance_meta.environment == "Dev" ? local.instance_size.t2_micro : local.instance_size.t2_small
  key_name                    = local.instance_meta.key_name
  vpc_security_group_ids      = [aws_security_group.webserver-sg.id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = file("install-nginx.sh")

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello, Terraform Cloud!'"
    ]

    connection {
      type        = "ssh"
      user        = local.instance_meta.ssh_user
      private_key = local.instance_meta.private_key
      host        = self.public_ip
    }
  }

  depends_on = [aws_security_group.webserver-sg]

  tags = merge(local.common_tags, {
    Name = "web-server"
  })
}

resource "aws_eip_association" "webserver_eip_association" {
  instance_id   = aws_instance.web-server.id
  allocation_id = aws_eip.webserver_eip.id
}
