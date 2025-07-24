#!/usr/bin/env bash

git_url='https://raw.githubusercontent.com/rhuanpk/linux/main/standard_scripts/.private/setload.sh'
final_path=${PK_LOAD_CFGBKP:-$(wget -qO - $git_url | bash - 2>&- | grep -F cfg-bkp)}/slim
prefix='sudo'

while getopts 'w' option; do
        [ "$option" = 'w' ] && unset prefix
done

shift $(($OPTIND-1))

$prefix ln -sfv ${final_path}/etc/slim.conf /etc/
$prefix ln -sfv ${final_path}/usr/share/slim/themes/my-theme /usr/share/slim/themes
