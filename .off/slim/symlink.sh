#!/usr/bin/bash

url_setpath='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setpath.sh'
[ -z "$PATH_CFGBKP" ] && source /etc/environment
path_cfgbkp="${PATH_CFGBKP:-$(curl -fsL "$url_setpath" | bash -s -- -p cfgbkp)}"

path_slim="$path_cfgbkp/slim"
sudo='sudo'

while getopts 'r' option; do
        [ "$option" = 'r' ] && unset sudo
done

shift $((OPTIND-1))

$sudo ln -sfv "$path_slim/etc/slim.conf" '/etc/'
$sudo ln -sfv "$path_slim/usr/share/slim/themes/theme" '/usr/share/slim/themes'
