// Master node server
resource "aws_instance" "k8s_master_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.k8s-master-server-key.key_name
  vpc_security_group_ids = [aws_security_group.k8s-master-server-sg.id]
  tags                   = {
    Name = var.master_server_name
  }

  provisioner "file" {
    source      = "./scripts/microk8s.sh"
    destination = "/tmp/microk8s.sh"
  }

  provisioner "file" {
    source      = "./deployment/my-web-app-deployment.yaml"
    destination = "/tmp/my-web-app-deployment.yaml"
  }

  provisioner "file" {
    source      = "./deployment/service.yaml"
    destination = "/tmp/service.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/microk8s.sh",
      "sudo /tmp/microk8s.sh"
    ]
  }

  connection {
    user        = var.user
    host        = self.public_ip
    private_key = file(var.master_key_path)
  }
}

// Worker node server
resource "aws_instance" "k8s_worker_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.k8s-worker-server-key.key_name
  vpc_security_group_ids = [aws_security_group.k8s-worker-server-sg.id]
  tags                   = {
    Name = var.worker_server_name
  }

  provisioner "file" {
    source      = "./scripts/microk8s.sh"
    destination = "/tmp/microk8s.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/microk8s.sh",
      "sudo /tmp/microk8s.sh"
    ]
  }

  connection {
    user        = var.user
    host        = self.public_ip
    private_key = file(var.worker_key_path)
  }
}

resource "null_resource" "execs" {
  provisioner "local-exec" {
    command = "ansible-playbook -e 'ansible_ssh_extra_args=\"-o StrictHostKeyChecking=no\"' -e 'master_server_ip=${aws_instance.k8s_master_server.public_ip}' -e 'worker_server_ip=${aws_instance.k8s_worker_server.public_ip}' ./ansible/playbook.yaml"
  }

  provisioner "remote-exec" {

    inline = [
      "microk8s kubectl apply -f /tmp/my-web-app-deployment.yaml",
      "microk8s kubectl apply -f /tmp/service.yaml"
    ]

    connection {
      user        = var.user
      host        = aws_instance.k8s_master_server.public_ip
      private_key = file(var.master_key_path)
    }
  }
}
