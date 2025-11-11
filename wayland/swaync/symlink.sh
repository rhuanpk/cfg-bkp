#!/usr/bin/bash

url_setpath='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setpath.sh'
[ -z "$PATH_CFGBKP" ] && source /etc/environment
path_cfgbkp="${PATH_CFGBKP:-$(curl -fsL "$url_setpath" | bash -s -- -p cfgbkp)}"

path_sway_src="$path_cfgbkp/wayland/swaync/style.css"
path_sway_dst="$HOME/.config/swaync"

mkdir -pv "$path_sway_dst/"
ln -sfv "$path_sway_src" "$path_sway_dst/"
