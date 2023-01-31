#!/bin/bash
if [ "$USER" != "root" ]; then
  echo "Please, run using sudo"
  exit 1
fi
apt update
apt upgrade
yes Y | apt install curl git mercurial make binutils bison gcc build-essential
yes Y | apt autoremove
# The following commands must be run as the current user, not as root user
sudo -u "$SUDO_USER" zsh << EOF
  zsh < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
  source "/home/$SUDO_USER/.gvm/scripts/gvm"
  gvm install go1.4 -B
  gvm use go1.4 --default
  export GOROOT_BOOTSTRAP=$GOROOT
EOF

printf "\n"
echo "After restarting your terminal or running source /home/$SUDO_USER/.gvm/scripts/gvm, you can install a go version:"
echo "  gvm install go1.19.5"
echo "  gvm use go1.19.5 --default"
echo "  go version"
