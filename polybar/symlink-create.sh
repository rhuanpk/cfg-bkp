#!/usr/bin/env bash
symlink_create() {
	ln -s /home/${USER}/Documents/git/cfg-bkp/polybar/config ${polybar_local_path}
}
polybar_local_path="/home/${USER}/.config/polybar"
[ ! -d ${polybar_local_path} ] && {
	mkdir -p ${polybar_local_path}
	symlink_create
} || symlink_create
