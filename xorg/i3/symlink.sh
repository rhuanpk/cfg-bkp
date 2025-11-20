#!/usr/bin/bash

url_setpath='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setpath.sh'
[ -z "$PATH_CFGBKP" ] && source /etc/environment
path_cfgbkp="${PATH_CFGBKP:-$(curl -fsL "$url_setpath" | bash -s -- -p cfgbkp)}"

path_i3_src="$path_cfgbkp/i3/config"
path_i3_dst="$HOME/.config/i3"

[ ! -d "$path_i3_dst" ] && mkdir -pv "$path_i3_dst"
ln -sfv "$path_i3_src" "$path_i3_dst"
