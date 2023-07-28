#!/usr/bin/env bash

user="`id -un 1000`"
home="/home/$user"
URL_SETLOAD='https://raw.githubusercontent.com/rhuanpk/linux/main/scripts/.private/setload.sh'
PATH_FINAL=${PK_LOAD_CFGBKP:-`wget -qO - "$URL_SETLOAD" | bash - 2>&- | grep 'cfg-bkp'`}/rofi
SUDO='sudo'

ROFI_CONFIG_PATH="$home/.config/rofi"
ROFI_CONFIG_FILE="$PATH_FINAL/config.rasi"
ROFI_CONFIG_FILE_OLD="$ROFI_CONFIG_PATH/config.rasi"
ROFI_THEME_PATH='/usr/share/rofi/themes'

symlink-create() {
	[ -e "$ROFI_CONFIG_FILE_OLD" ] && rm -fv "$ROFI_CONFIG_FILE_OLD"
	eval "${PREFIX:+$PREFIX "'"} ln -sfv '$ROFI_CONFIG_FILE' '$ROFI_CONFIG_PATH/' ${PREFIX:+"'"}"
	$SUDO ln -sfv "$PATH_FINAL/my-dmenu.rasi" "$ROFI_THEME_PATH/"
}

[ '-w' = "$1" ] && {
	PREFIX="su $user -c --"
	unset SUDO
	shift
}

[ ! -d "$ROFI_CONFIG_PATH/" ] && {
	eval "${PREFIX:+$PREFIX "'"} mkdir -pv '$ROFI_CONFIG_PATH/' ${PREFIX:+"'"}"
	symlink-create
} || symlink-create
