# Disable the pinetry GUI window
unset GPG_AGENT_INFO
unset SSH_ASKPASS

# Editor
export EDITOR='vim'
export VISUAL='vi'

export GOPATH=$HOME/.gopath/

os_name=`uname`

if [[ $os_name == "Darwin" ]]; then
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
fi
