#!/bin/bash
sudo apt install zsh
sudo apt-get install powerline fonts-powerline
chsh -s $(which zsh)
zsh
echo 'ZSH_THEME="robbyrussell"' >> ~/.zshrc
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
