#!/usr/bin/env bash

home=${HOME:-"/home/${USER:-`whoami`}"}
fonts_directory=${home}/Documents/fonts

print_infos()  {
	status=${1:?need a status to inform!}
	[ $status = true ] && {
		color=32
		message=installed
	} || {
		color=33
		message=installing
	}
	cat <<- eof
		» `formatter 35 font_name`: `formatter 1 ${font_name}` (`formatter ${color} ${message}`)
		→ `formatter 35 font_type`: ${font_type}
		→ `formatter 35 install_path`: ${install_path}/

	eof
}

formatter() {
	formatting="${1}"
	[[ "${formatting}" =~ ([[:digit:]]+;?)* ]] && message="${@:2}" || message="${*}"
	echo -e "\e[${formatting}m${message}\e[m"
}

[ ! -d $fonts_directory ] && {
	echo 'do not finded fonts directory! exiting...'
	exit 1
}

cd /tmp
echo -e "\n>>> `formatter 36 fonts directory`: ${fonts_directory} !\n"

for font in ${fonts_directory}/*; do

	font_name="`basename ${font%.?[tT][fF]}`"
	font_type=${font#*.}
	install_path=${home}/.local/share/fonts

	if [ ${font_type,,} = ttf ]; then
		install_path+=/truetype/${font_name}
	elif [ ${font_type,,} = otf ]; then
		install_path+=/opentype/${font_name}
	else
		echo "font: `basename "${font}"`: wrong type! continuing..."
		continue
	fi

	[ ! -d $install_path ] && {
		print_infos false
		mkdir -pv ${install_path}/
		echo -e "cp: copying file `cp -v "${font}" ${install_path}/`\n"
	} || print_infos true

done
