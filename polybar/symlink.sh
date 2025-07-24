#!/usr/bin/env bash

home=${HOME:-"/home/${USER:-$(whoami)}"}
polybar_local_path="${home}/.config/polybar"
git_url='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setload.sh'
final_path=${PK_LOAD_CFGBKP:-$(wget -qO - $git_url | bash - 2>&- | grep -F cfg-bkp)}/polybar/config.ini

symlink_create() {
	ln -sfv $final_path ${polybar_local_path}
}

[ ! -d ${polybar_local_path} ] && {
	mkdir -p ${polybar_local_path}
	symlink_create
} || symlink_create
