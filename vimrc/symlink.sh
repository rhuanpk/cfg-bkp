#!/usr/bin/env bash

home=${HOME:-"/home/${USER:-$(whoami)}"}
git_url='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setload.sh'
final_path=${PK_LOAD_CFGBKP:-$(wget -qO - $git_url | bash - 2>&- | grep -F cfg-bkp)}/vimrc/.vimrc

ln -sfv "$final_path" "$home/"
