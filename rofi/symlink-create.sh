#!/usr/bin/env bash

home=${HOME:-"/home/${USER:-$(whoami)}"}
git_url='https://raw.githubusercontent.com/rhuan-pk/linux/master/scripts/.private/setload.sh'
final_path=${PK_LOAD_CFGBKP:-$(wget -qO - $git_url | bash - 2>&- | grep -F cfg-bkp)}/rofi

rofi_config_path="${home}/.config/rofi"
rofi_config_file="${final_path}/config.rasi"
rofi_config_file_old="${rofi_config_path}/config.rasi"
rofi_theme_path=/usr/share/rofi/themes/

symlink_create() {
	[ -e ${rofi_config_file_old} ] && rm -fv ${rofi_config_file_old}
	ln -sfv ${rofi_config_file} ${rofi_config_path}
	sudo ln -sfv ${final_path}/my-dmenu.rasi ${rofi_theme_path}
}

[ ! -d ${rofi_config_path} ] && {
	mkdir -pv ${rofi_config_path}
	symlink_create
} || symlink_create
