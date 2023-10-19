data "http" "ipinfo" {
  url = var.ip_info_url
}

# k8s master server security group
resource "aws_security_group" "k8s-master-server-sg" {
  name        = var.master_security_group_name
  description = var.master_security_group_name

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      format("%s/32", jsondecode(data.http.ipinfo.response_body).ip)
    ] # Allow SSH from MY IP only
  }

  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.k8s-worker-server-sg.id]
  }

  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "udp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.k8s-worker-server-sg.id]
  }

  ingress {
    from_port       = -1
    to_port         = -1
    protocol        = "icmp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.k8s-worker-server-sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    security_groups  = [aws_security_group.k8s-worker-server-sg.id]
  }
}

# k8s worker server security group
resource "aws_security_group" "k8s-worker-server-sg" {
  name        = var.worker_security_group_name
  description = var.worker_security_group_name

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}