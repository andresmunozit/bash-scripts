#!/bin/bash
yes Y | apt install git
apt install curl
apt install git
apt --purge remove zsh
apt install zsh
apt install powerline fonts-powerline
chsh -s $(which zsh)
yes Y | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo 'ZSH_THEME="robbyrussell"' >> ~/.zshrc
