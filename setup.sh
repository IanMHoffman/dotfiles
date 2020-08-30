#!/bin/bash

##============================================================================##
## description  UNIX configuration files installer
## author       IanMHoffman

##============================================================================##
## exec option

set -e # first error to exit

##============================================================================##
## definitions
# .dotfiles

DOTFILES_REPOSITORY="https://github.com/IanMHoffman/dotfiles"
DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_LINK_DIR="$DOTFILES_DIR/dotfiles_link"
# Oh My Zsh
OHMYZSH_DIR="$HOME/.oh-my-zsh"

##============================================================================##
## opening

echo '                                                                          '
echo '                                                                          '
echo '         88                          ad88  88  88                         '
echo '         88                ,d       13`    37  88                         '
echo '         88                88       88         88                         '
echo ' ,adPPYb,88   ,adPPYba,  MM88MMM  MM88MMM  88  88   ,adPPYba,  ,adPPYba,  '
echo 'a8`    `Y88  a8`     `8a   88       88     88  88  a8P_____88  I8[    ``  '
echo '8b       88  8b       d8   88       88     88  88  8PP```````   ``Y8ba,   '
echo '`8a,   ,d88  `8a,   ,a8`   88,      88     88  88  `8b,   ,aa  aa    ]8I  '
echo ' ``8bbdP`Y8   ``YbbdP``    `Y888    88     88  88   ``Ybbd8``  ``YbbdP``  '
echo '                                                                          '
echo '                                                                          '

##============================================================================##
## required commands check

REQUIRED_COMMANDS=("git" "zsh" "curl")
for cmd in ${REQUIRED_COMMANDS[@]}; do
    if ! type $cmd >/dev/null 2>&1; then
        echo "WHY DIDN'T YOU INSTALL $cmd FIRST?!?!"
        exit 1
    fi
done
echo "OK ${REQUIRED_COMMANDS[@]}"

##============================================================================##
## clone .dotfiles if it does not exist

if [ -d $DOTFILES_DIR ]; then
    pushd $DOTFILES_DIR >/dev/null
    git pull
    popd >/dev/null
else
    git clone $DOTFILES_REPOSITORY $DOTFILES_DIR
fi
echo "OK $DOTFILES_DIR"

##============================================================================##
## oh-my-zsh

if [ ! -d $OHMYZSH_DIR ]; then
    echo 'installing oh-my-zsh'
    echo exit | sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
echo "OK oh-my-zsh"

## Zsh Powerlevel10k theme
## see https://github.com/romkatv/powerlevel10k#oh-my-zsh
ZSH_THEME_P10K_DIR=$OHMYZSH_DIR/custom/themes/powerlevel10k
if [ ! -d $ZSH_THEME_P10K_DIR ]; then
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_THEME_P10K_DIR
fi
echo "OK zsh Powerlevel10k theme"

## Fast Syntax Highlighting (F-Sy-H)
## see https://github.com/zdharma/fast-syntax-highlighting
ZSH_CUSTOM=$OHMYZSH_DIR/custom
ZSH_SYNTAX_HIGHLIGHTING=$ZSH_CUSTOM/plugins/fast-syntax-highlighting
if [ ! -d $ZSH_SYNTAX_HIGHLIGHTING ]; then
    echo 'installing zsh syntax highlighting'
    git clone https://github.com/zdharma/fast-syntax-highlighting $ZSH_SYNTAX_HIGHLIGHTING
fi
echo "OK zsh syntax highlighting"

##============================================================================##
## link .dotfiles

pushd $DOTFILES_LINK_DIR >/dev/null
dotfiles_link=$(find . -type f)
for file in ${dotfiles_link[@]}; do
    file=${file#./} # remove first "./"
    echo "  $file"
    mkdir -p $HOME/$(dirname $file)
    ln -sf $DOTFILES_LINK_DIR/$file $HOME/$file
done
popd >/dev/null
echo "OK Symbolic Links"

##============================================================================##

./scripts/pt_install_programs.sh
./scripts/programs.sh
./scripts/desktop_enviroment.sh

# Retrieve the newest versions
sudo apt upgrade -y

# see the changes to your bashrc
source ~/.bashrc

figlet "Your 1337 H4X0R enviroment has been initialized!" | lolcat

