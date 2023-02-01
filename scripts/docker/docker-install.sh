#!/bin/bash
if [ "$USER" != "root" ]; then
  echo "Please, run this script with sudo"
  exit 1
fi
# See https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04
apt update
apt upgrade
yes Y | apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt-cache policy docker-ce
yes Y | sudo apt install docker-ce
systemctl status docker
usermod -aG docker "$SUDO_USER"
