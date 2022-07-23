#!/usr/bin/env bash
symlink_create() {
	[ -e ${rofi_config_file_old} ] && rm -fv ${rofi_config_file_old}
	ln -svf ${rofi_config_file} ${rofi_config_path}
	sudo ln -svf /home/${USER}/Documents/git/cfg-bkp/rofi/my-dmenu.rasi ${rofi_theme_path}
}
rofi_config_path="/home/${USER}/.config/rofi"
rofi_config_file="/home/${USER}/Documents/git/cfg-bkp/rofi/config.rasi"
rofi_config_file_old="${rofi_config_path}/config.rasi"
rofi_theme_path=/usr/share/rofi/themes/
[ ! -d ${rofi_config_path} ] && {
	mkdir -pv ${rofi_config_path}
	symlink_create
} || symlink_create
