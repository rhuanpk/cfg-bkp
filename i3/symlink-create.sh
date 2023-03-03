#!/usr/bin/env bash

home=${HOME:-"/home/${USER:-$(whoami)}"}
i3_local_path=${home}/.config/i3
git_url='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setload.sh'
final_path=${PK_LOAD_CFGBKP:-$(wget -qO - $git_url | bash - 2>&- | grep -F cfg-bkp)}/i3/config

symlink_create() {
	ln -sfv $final_path $i3_local_path
}

[ ! -d $i3_local_path ] && {
	mkdir -p $i3_local_path
	symlink_create
} || symlink_create
