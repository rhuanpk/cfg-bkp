#!/usr/bin/env bash

home=${HOME:-"/home/${USER:-$(whoami)}"}
config_path=${home}/.config/noti
file=noti.yaml

[ ! -d $config_path ] && mkdir -pv $config_path
toplip -c 3 -d ./${file} > ${config_path}/${file}
