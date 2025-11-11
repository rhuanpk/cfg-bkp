#!/usr/bin/bash

url_setpath='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setpath.sh'
[ -z "$PATH_CFGBKP" ] && source /etc/environment
path_cfgbkp="${PATH_CFGBKP:-$(curl -fsL "$url_setpath" | bash -s -- -p cfgbkp)}"

path_waybar_config_src="$path_cfgbkp/wayland/waybar/config.jsonc"
path_waybar_style_src="$path_cfgbkp/wayland/waybar/style.css"
path_waybar_power_src="$path_cfgbkp/wayland/waybar/custom/power.xml"

path_waybar_dst="$HOME/.config/waybar"
path_waybar_mods_dst="$HOME/.config/waybar/custom"

mkdir -pv "$path_waybar_dst/" "$path_waybar_mods_dst"
ln -sfv "$path_waybar_config_src" "$path_waybar_dst/"
ln -sfv "$path_waybar_style_src" "$path_waybar_dst/"
ln -sfv "$path_waybar_power_src" "$path_waybar_mods_dst/"
