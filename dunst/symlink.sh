#!/usr/bin/bash

url_setpath='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setpath.sh'
[ -z "$PATH_CFGBKP" ] && source /etc/environment
path_cfgbkp="${PATH_CFGBKP:-$(curl -fsL "$url_setpath" | bash -s -- -p cfgbkp)}"

path_dunst_src="$path_cfgbkp/dunst/dunstrc"
path_dunst_dst="$HOME/.config/dunst"

[ ! -d "$path_dunst_dst" ] && mkdir -pv "$path_dunst_dst"
ln -sfv "$path_dunst_src" "$path_dunst_dst"
