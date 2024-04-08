#!/usr/bin/env bash

script=$(basename `readlink -f "$0"`)
sudo='sudo'

while getopts 'r' option; do
        [ "$option" = 'r' ] && unset sudo
done
shift $(($OPTIND-1))

$sudo tee -a /etc/sysctl.d/99-sysctl.conf <<- \eof
	vm.swappiness=1
	vm.vfs_cache_pressure=50
eof
