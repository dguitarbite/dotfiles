antigen bundle zsh-users/zsh-syntax-highlighting
antigen theme XsErG/zsh-themes themes/lazyuser

antigen use oh-my-zsh

antigen bundle <<EOBUNDLE

git
pip
pep8
lein
suse
sudo
pyenv
heroku
python
pylint
autoenv
history
colorize
git-glow
gitignore
gpg-agent
ssh-agent
archlinux
gnu-utils
git-extras
git-prompt
git-remote-branch
command-not-found
Tarrasch/zsh-autoenv
zsh-users/history-substring-search
zsh-users/zsh-syntax-highlighting


EOBUNDLE

antigen theme XsErG/zsh-themes themes/lazyuser
# Keep at end, tell antigen that you are done.
antigen apply

setopt nocorrectall
