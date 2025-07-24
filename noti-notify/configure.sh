#!/usr/bin/bash

config_path="$HOME/.config/noti"
file='noti.yaml'

[ ! -d "$config_path" ] && mkdir -pv "$config_path"
cp -fv "./$file" "$config_path/$file"
