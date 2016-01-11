# Disable the pinetry GUI window
unset GPG_AGENT_INFO
unset SSH_ASKPASS

# Editor
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nano'
fi


source #{HOME}/deep_learning/distro/install/bin/torch-activate
