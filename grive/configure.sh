#!/usr/bin/env bash

script=${0}
home=${HOME:-"/home/${USER:-$(whoami)}"}
folder=${home}/googleDrive

[ ! -d $folder ] && { mkdir -pv $folder; cd $folder; } || { echo 'Folder already exists?? :/'; exit 1; }
if ! grive -a; then
	echo "${script}: Error in grive configuration!"
	rm -rfv $folder
	exit 1
else
	echo "${script}: Success in grive configuration!"
fi
sudo tee /etc/systemd/system/grive.service <<- eof
	[Unit]
	Description=CLI synchronizer service for GoogleDrive!

	[Service]
	WorkingDirectory=${folder}
	ExecStart=grive
	Restart=always
	RestartSec=300
	RuntimeMaxSec=3600

	[Install]
	WantedBy=multi-user.target
eof
if ! sudo systemctl enable grive.service; then
	echo "${script}: Error on enabling service!"
	rm -rfv $folder
	exit 1
else
	echo "${script}: Success on enabling service!"
fi
