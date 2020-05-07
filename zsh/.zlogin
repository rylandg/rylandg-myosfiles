# Start configuration added by Zim install {{{
#
# User configuration sourced by login shells
#
# Initialize Zim
# source ${ZIM_HOME}/login_init.zsh -q &!
# }}} End configuration added by Zim install

# Initialize zim
#[[ -s ${ZIM_HOME}/login_init.zsh ]] && source ${ZIM_HOME}/login_init.zsh

if [[ "$SSH_CONNECTION" != "" && "$MY_SSH_CONNECTION" != "yes" ]]; then
    while true; do
        echo -n "Do you want to attach to a tmux session? [y/n]"
        read yn
        case $yn in
            [Yy]* ) MY_SSH_CONNECTION="yes" tmux new-session -s development -A; break;;
            [Nn]* ) break;;
            * ) echo "Please answer y/n";;
        esac
    done
fi
