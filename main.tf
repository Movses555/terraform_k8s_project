resource "aws_instance" "k8s_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.k8s-server-key.key_name
  vpc_security_group_ids = [aws_security_group.k8s-server-sg.id]
  tags = {
    Name = var.server_name
  }
}