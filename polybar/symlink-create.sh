#!/usr/bin/env bash

home=${HOME:-"/home/${USER:-$(whoami)}"}
polybar_local_path="${home}/.config/polybar"
git_url='https://raw.githubusercontent.com/rhuan-pk/comandos-linux/master/standard_scripts/.pessoal/setload.sh'
final_path=${PK_LOAD_CFGBKP:-$(wget -qO - $git_url | bash - 2>&- | grep -F cfg-bkp)/polybar/config}

symlink_create() {
	ln -sfv $final_path ${polybar_local_path}
}

[ ! -d ${polybar_local_path} ] && {
	mkdir -p ${polybar_local_path}
	symlink_create
} || symlink_create
