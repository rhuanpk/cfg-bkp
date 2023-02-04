#!/usr/bin/env bash

home=${HOME:-"/home/${USER:-$(whoami)}"}
git_url='https://raw.githubusercontent.com/rhuan-pk/linux/master/scripts/.private/setload.sh'
final_path=${PK_LOAD_CFGBKP:-$(wget -qO - $git_url | bash - 2>&- | grep -F cfg-bkp)}/my-theme
pk_command="ln -sfv ${final_path}/*.zsh-theme"
pk_target='.oh-my-zsh/custom/themes/'

[ "${1}" = '/root' ] && {
	eval sudo '${pk_command} /root/${pk_target}'
} || {
	eval '${pk_command} ${home}/${pk_target}'
}
