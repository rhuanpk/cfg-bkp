#!/usr/bin/env bash

script=${0}
home=${HOME:-"/home/${USER:-$(whoami)}"}
folder=${home}/googleDrive

[ ! -d $folder ] && { mkdir -pv $folder; cd $folder; } || cd $folder
if ! grive -a; then
	echo "${script}: Error in grive configuration!"
	exit 1
else
	echo "${script}: Success in grive configuration!"
fi
sudo tee /etc/systemd/system/grive.service <<- eof
	[Unit]
	Description=CLI synchronizer service for GoogleDrive

	[Service]
	WorkingDirectory=${folder}
	ExecStart=grive
	Restart=always
	RestartSec=10
eof
if ! sudo systemctl enable --now grive.service; then
	echo "${script}: Error on enabling service!"
	exit 1
else
	echo "${script}: Success on enabling service!"
fi
