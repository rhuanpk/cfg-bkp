#!/usr/bin/bash

url_setpath='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setpath.sh'
path_cfgbkp="${PATH_CFGBKP:-$(curl -fsL "$url_setpath" | bash -s -- -p cfgbkp)}"
path_bash_aliases="$path_cfgbkp/rc/bash_aliases"
path_bash_functions="$path_cfgbkp/rc/bash_functions"
path_bash_local="$path_cfgbkp/rc/bash_local"
source_bash=''

ln -sfv "$path_bash_aliases" "$HOME/.${path_bash_aliases##*/}"
ln -sfv "$path_bash_functions" "$HOME/.${path_bash_functions##*/}"
ln -sfv "$path_bash_local" "$HOME/.${path_bash_local##*/}"

if ! grep -qE '^source "\$PATH_CFGBKP/rc/bashrc"$' ~/.bashrc; then
	echo -e "\nsource \"\$PATH_CFGBKP/rc/bashrc\"" >> ~/.bashrc
fi
