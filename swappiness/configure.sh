
#!/usr/bin/env bash

script=$(basename "${0}")

sudo tee /etc/systemd/system/swappiness.service <<- eof
	[Unit]
	Description=Set vm.swappiness to 10!

	[Service]
	ExecStart=sysctl vm.swappiness=10
	Restart=on-failure
	RestartSec=30

	[Install]
	WantedBy=multi-user.target
eof
if ! sudo systemctl enable swappiness.service; then
	echo "${script}: Error on enabling service!"
	exit 1
else
	echo "${script}: Success on enabling service!"
fi
