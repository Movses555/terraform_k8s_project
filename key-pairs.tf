# k8s master server key-pair
resource "aws_key_pair" "k8s-master-server-key" {
  key_name   = "k8s-master-server-key"
  public_key = file("./keys/k8s-master-server-key.pub")
}

# k8s worker server key-pair
resource "aws_key_pair" "k8s-worker-server-key" {
  key_name   = "k8s-worker-server-key"
  public_key = file("./keys/k8s-worker-server-key.pub")
}