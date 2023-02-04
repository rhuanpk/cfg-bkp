#!/usr/bin/env bash

git_url='https://raw.githubusercontent.com/rhuan-pk/linux/master/standard_scripts/.private/setload.sh'
final_path=${PK_LOAD_CFGBKP:-$(wget -qO - $git_url | bash - 2>&- | grep -F cfg-bkp)}/slim

sudo ln -s ${final_path}/etc/slim.conf /etc/
sudo ln -s ${final_path}/usr/share/slim/themes/my-theme /usr/share/slim/themes
