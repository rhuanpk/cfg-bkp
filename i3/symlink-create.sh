#!/usr/bin/env bash
symlink_create() {
	ln -svf /home/${USER}/Documents/git/cfg-bkp/i3/config ${i3_local_path}
}
i3_local_path="/home/${USER}/.config/i3"
[ ! -d ${i3_local_path} ] && {
	mkdir -p ${i3_local_path}
	symlink_create
} || symlink_create
