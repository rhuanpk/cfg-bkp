#!/usr/bin/bash

url_setpath='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setpath.sh'
[ -z "$PATH_CFGBKP" ] && source /etc/environment
path_cfgbkp="${PATH_CFGBKP:-$(curl -fsL "$url_setpath" | bash -s -- -p cfgbkp)}"

path_rofi_src="$path_cfgbkp/rofi"
path_rofi_dst="$HOME/.config/rofi"

path_rofi_cfg_src="$path_rofi_src/config.rasi"
path_rofi_cfg_dst="$path_rofi_dst/config.rasi"

path_rofi_theme_src="$path_rofi_src/theme.rasi"
path_rofi_theme_dst='/usr/share/rofi/themes/theme.rasi'

[ ! -d "$path_rofi_dst" ] && mkdir -pv "$path_rofi_dst"
ln -sfv "$path_rofi_cfg_src" "$path_rofi_cfg_dst"
ln -sfv "$path_rofi_theme_src" "$path_rofi_theme_dst"
