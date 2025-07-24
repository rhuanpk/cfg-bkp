#!/usr/bin/env bash

script="$0"
folder="$HOME/googleDrive"
prefix='sudo'

while getopts 'w' option; do
	[ "$option" = 'w' ] && unset prefix
done

shift $((OPTIND-1))

[ ! -d "$folder" ] && {
	mkdir -pv "$folder"
	cd "$folder"
} || {
	echo "$script: folder already exists? :/"
	exit 1
}

if ! grive -a; then
	echo "$script: error in grive configuration"
	rm -rfv "$folder"
	exit 1
else
	echo "$script: success in grive configuration"
fi

$prefix tee /etc/systemd/system/grive.service <<- eof
	[Unit]
	Description=CLI synchronizer service for GoogleDrive.

	[Service]
	WorkingDirectory=$folder
	ExecStart=grive
	Restart=always
	RestartSec=300
	RuntimeMaxSec=3600

	[Install]
	WantedBy=multi-user.target
eof
if ! $prefix systemctl enable grive.service; then
	echo "$script: error on enabling service"
	rm -rfv "$folder"
	exit 1
else
	echo "$script: success on enabling service"
fi
