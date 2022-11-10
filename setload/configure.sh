#!/usr/bin/env bash

# Create daemon for `setload` script.

# 1. copiar o `setload` para `/usr/local/bin/`.
# 2. rodar este *script*.
# 3. definir as variáveis em `/etc/environment`.
# 	- `export PK_LOAD_CFGBKP=null`.
#	- `export PK_LOAD_LINUXCOMMANDS=null`.
# 	- `export PK_LOAD_PKUTILS=null`.
# 4. definir o `source` nos `*rc`'s.
# 	- `source $PK_LOAD_LINUXCOMMANDS`.

script=${0}

sudo tee /etc/systemd/system/setload.service <<- eof
	[Unit]
	Description=Load standard environment variables!

	[Service]
	WorkingDirectory=/tmp
	ExecStart=setload

	[Install]
	WantedBy=multi-user.target
eof
[ $? -ne 0 ] && {
	echo "${script}: Error on create systemd unit file!"
	exit 1
} || {
	echo "${script}: Success on create systemd unit file!"
}
if ! sudo systemctl enable setload.service; then
	echo "${script}: Error on enabling service!"
	exit 1
else
	echo "${script}: Success on enabling service!"
fi
