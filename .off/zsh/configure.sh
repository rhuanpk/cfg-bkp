#!/usr/bin/bash

url_setpath='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setpath.sh'
[ -z "$PATH_CFGBKP" ] && source /etc/environment
path_cfgbkp="${PATH_CFGBKP:-$(curl -fsL "$url_setpath" | bash -s -- -p cfgbkp)}"

path_zsh="$path_cfgbkp/my-theme"
ln -sfv "$path_zsh"/*.zsh-theme "$HOME/.oh-my-zsh/custom/themes/"
