#!/usr/bin/env bash
normal_user="$(whoami)"
pk_command="ln -sf /home/${normal_user}/Documents/git/cfg-bkp/my-theme/*.zsh-theme"
pk_target='.oh-my-zsh/custom/themes/'
[ "${1}" = '/root' ] && {
	home_path='/root'
	eval sudo '${pk_command} ${home_path}/${pk_target}'
} || {
	home_path="/home/${USER}"
	eval '${pk_command} ${home_path}/${pk_target}'
}
