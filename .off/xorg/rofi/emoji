#!/usr/bin/bash

file="${XDG_DATA_HOME:-$HOME/.local/share}/emojis.txt"
url='https://unicode.org/Public/emoji/latest/emoji-test.txt'

if [ ! -f "$file" ] || test $(find "$file" -mmin +259200); then
	curl -fsSL "$url" | \
	sed -nE '{
		/(^#|^$)/d
		s/^.*#\s+([^\sE]+)\sE[0-9\.]+\s(.*)$/\1\t\2/p
	}' > "$file"
fi

case "$ROFI_RETV" in
	0)
		echo -en "\x00prompt\x1femoji\n"
		cat "$file"
	;;
	1)
		chosen="${1%%[[:space:]]*}"
		[ -z "$chosen" ] && exit 0
		coproc {
			printf '%s' "$chosen" | xclip -sel clip 2>&-
			printf '%s' "$chosen" | wl-copy 2>&-
			notify-send "$0" "The '$chosen' emoji copied to clipboard."
		} &>/dev/null
	;;
	*) echo "$0: error: need to run from rofi"; exit 1;;
esac
