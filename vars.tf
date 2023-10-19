variable "ami" {
  type    = string
  default = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  type    = string
  default = "t3.xlarge"
}

variable "master_server_name" {
  type    = string
  default = "K8S-Master-Server"
}

variable "worker_server_name" {
  type    = string
  default = "K8S-Worker-Server"
}

variable "user" {
  type    = string
  default = "ubuntu"
}

variable "master_key_path" {
  type    = string
  default = "./keys/k8s-master-server-key.pem"
}

variable "worker_key_path" {
  type    = string
  default = "./keys/k8s-worker-server-key.pem"
}

variable "master_security_group_name" {
  type    = string
  default = "k8s_master_security_group"
}

variable "worker_security_group_name" {
  type    = string
  default = "k8s_worker_security_group"
}

variable "ip_info_url" {
  type    = string
  default = "https://ipinfo.io"
}