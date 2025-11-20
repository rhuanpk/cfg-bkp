#!/usr/bin/bash

url_setpath='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setpath.sh'
[ -z "$PATH_CFGBKP" ] && source /etc/environment
path_cfgbkp="${PATH_CFGBKP:-$(curl -fsL "$url_setpath" | bash -s -- -p cfgbkp)}"

path_polybar_src="$path_cfgbkp/polybar/config.ini"
path_polybar_dst="$HOME/.config/polybar"

[ ! -d "$path_polybar_dst" ] && mkdir -pv "$path_polybar_dst"
ln -sfv "$path_polybar_src" "$path_polybar_dst"
