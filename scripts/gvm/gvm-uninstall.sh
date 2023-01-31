#!/bin/bash
if [ "$USER" != "root" ]; then
  echo "Please, run using sudo"
  exit 1
fi
rm -rf "/home/$SUDO_USER/.gvm"
