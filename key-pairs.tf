# k8s server key-pair
resource "aws_key_pair" "k8s-server-key" {
  key_name   = "k8s-server-key"
  public_key = file("./keys/k8s-server-key.pub")
}