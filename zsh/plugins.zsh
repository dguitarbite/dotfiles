antigen use oh-my-zsh

antigen bundles <<EOBUNDLE

# Source Control
git
git-flow
git-fast
gitignore
git-extras
git-prompt
github/hub
git-remote-branch

# Python
pip
pep8
pyenv
python
pylint

# Operating System
yum
osx
brew
suse
debian
fedora
brew-cask
archlinux

# Auth
gpg-agent
ssh-agent

# Misc
docker

# GNU - Terminal
tumx
sudo
rsync
iwhois
screen
vi-mode
history
colorize
gnu-utils
command-not-found
colored-man-pages
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-history-substring-search

# Zsh theme, order dependent.
mafredri/zsh-async
sindresorhus/pure

EOBUNDLE

antigen apply

antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure

setopt nocorrectall
