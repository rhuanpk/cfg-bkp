#!/usr/bin/env bash

home=${HOME:-"/home/${USER:-$(whoami)}"}
dunst_local_path=${home}/.config/dunst
git_url='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setload.sh'
final_path=${PK_LOAD_CFGBKP:-$(wget -qO - $git_url | bash - 2>&- | grep -F cfg-bkp)}/dunst/dunstrc

[ ! -d $i3_local_path ] && mkdir -p "$i3_local_path"
ln -sfv "$final_path" "$i3_local_path"
