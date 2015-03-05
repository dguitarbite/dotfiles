#!/usr/bin/env bash

export base_dir="${PWD}"
export target="${HOME}"

# Initialize zsh stuff
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

# Create Links ...

# Initialize Vundle
git clone git://github.com/gmarik/vundle.git $target/.vim/bundle/vundle


vim +BundleInstall! +qall #2&> /dev/null


bash $target/.vim/bundle/YouCompleteMe/install.sh


git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
# Install Pretzo for zsh
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
      ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
chsh -s /bin/zsh

