#!/usr/bin/env bash

url_setpath='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setpath.sh'
path_cfgbkp="${PATH_CFGBKP:-$(curl -fsL "$url_setpath" | bash -s -- -p cfgbkp)}"
path_vimrc="$path_cfgbkp/vimrc/.vimrc"

ln -sfv "$final_path" "$HOME/"
