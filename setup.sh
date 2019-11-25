#!/bin/bash

./scripts/pt_install_programs.sh
./scripts/programs.sh
./scripts/desktop_enviroment.sh

# Retrieve the newest versions
sudo apt upgrade -y

# see the changes to your bashrc
source ~/.bashrc

figlet "Your 1337 H4KS0RZ enviroment has been initialized!" | lolcat

