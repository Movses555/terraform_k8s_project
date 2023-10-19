#!/bin/bash
sudo snap install microk8s --classic
sudo ufw allow in on cni0 && sudo ufw allow out on cni0
sudo ufw default allow routed
sudo usermod -a -G microk8s ubuntu
# shellcheck disable=SC1090
source ~/.bashrc
microk8s start
