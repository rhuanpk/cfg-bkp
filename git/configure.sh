#!/usr/bin/bash

url_setpath='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setpath.sh'
[ -z "$PATH_CFGBKP" ] && source /etc/environment
path_cfgbkp="${PATH_CFGBKP:-$(curl -fsL "$url_setpath" | bash -s -- -p cfgbkp)}"
: ${path_cfgbkp:?path cfgbkp must be set}

path_gitconfig="$path_cfgbkp/git/.gitconfig"

path_config_src="$path_cfgbkp/git/config"
path_config_dst="$HOME/.git"

mkdir -pv "$path_config_dst"
ln -sfv "$path_gitconfig" "$HOME/"
cp -fv "$path_config_src" "$path_config_dst/"
