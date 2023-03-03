#!/usr/bin/env bash

home=${HOME:-"/home/${USER:-$(whoami)}"}
git_url='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setload.sh'
final_path=${PK_LOAD_CFGBKP:-$(wget -qO - $git_url | bash - 2>&- | grep -F cfg-bkp)}/rc/bashrc

symlink_create() {
	ln -sfv $final_path ${home}/.bashrc
}

[ ! -d $home ] && {
	mkdir -pv $home
	symlink_create
} || symlink_create
