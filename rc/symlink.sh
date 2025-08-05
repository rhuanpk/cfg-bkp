#!/usr/bin/bash

url_setpath='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setpath.sh'
[ -z "$PATH_CFGBKP" ] && source /etc/environment
path_cfgbkp="${PATH_CFGBKP:-$(curl -fsL "$url_setpath" | bash -s -- -p cfgbkp)}"

path_bash_aliases="$path_cfgbkp/rc/bash_aliases"
path_bash_functions="$path_cfgbkp/rc/bash_functions"
path_bash_local="$path_cfgbkp/rc/bash_local"
path_bash_vars="$path_cfgbkp/rc/bash_vars"
source_bash=''

ln -sfv "$path_bash_aliases" "$HOME/.${path_bash_aliases##*/}"
ln -sfv "$path_bash_functions" "$HOME/.${path_bash_functions##*/}"

cp -fv "$path_bash_local" "$HOME/.${path_bash_local##*/}"
cp -fv "$path_bash_vars" "$HOME/.${path_bash_vars##*/}"

if ! grep -qF '. "$HOME/.bash_vars"' ~/.profile; then
	tee -a ~/.profile <<- \eof

	[ -r "$HOME/.bash_vars" ] && . "$HOME/.bash_vars"
	eof
fi

if ! grep -qF '. "$PATH_CFGBKP/rc/bashrc"' ~/.bashrc; then
	tee -a ~/.bashrc <<- \eof

	[ -r "$PATH_CFGBKP/rc/bashrc" ] && . "$PATH_CFGBKP/rc/bashrc"
	eof
fi
