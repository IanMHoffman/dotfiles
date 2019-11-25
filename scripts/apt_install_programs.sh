#!/bin/bash

sudo apt update

function install {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    echo "Installing: ${1}..."
    sudo apt install -y $1
  else
    echo "Already installed: ${1}"
  fi
}

# Basics
install awscli
install chromium-browser
install curl
install exfat-utils
install file
install git
install htop
install nmap
install tmux
install vim
install wget
install peco
install zsh
install terminator
install zathura
install latexmk


# STM32 Development
install gcc-arm-none-eabi
install binutils-arm-none-eabi
install libnewlib-arm-non-eabi
install codeblocks

# Just for lolz
install figlet
install lolcat

