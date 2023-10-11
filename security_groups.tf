data "http" "ipinfo" {
  url = var.ip_info_url
}

# Applications servers security group
resource "aws_security_group" "k8s-server-sg" {
  name        = var.security_group_name
  description = var.security_group_name

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [format("%s/32", jsondecode(data.http.ipinfo.response_body).ip)] # Allow SSH from MY IP only
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # Allow traffic from anywhere IPv4
    ipv6_cidr_blocks = ["::/0"]      # Allow traffic from anywhere IPv6
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}