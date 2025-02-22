#!/usr/bin/bash

sudo='sudo'

while getopts 'r' option; do
        [ "$option" = 'r' ] && unset sudo
done
shift $(($OPTIND-1))

$sudo mkdir -p /etc/sysctl.d/

$sudo tee -a /etc/sysctl.d/99-sysctl.conf <<- \eof
	vm.swappiness=10
	vm.vfs_cache_pressure=75
eof
