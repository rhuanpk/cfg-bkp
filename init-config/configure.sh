#!/usr/bin/env bash

##################################################################################################################################
#
# *** pos installations ***
#
# >>> configuração manual !
#
# - pcloud;
# - oh-my-zsh;
# - gtk;
# - qt5ct;
# - thunar;
# - touchpad;
#
# -----------------------
#
# >>> crontab
#
# - 0 * * * * export DISPLAY=:0; /usr/local/bin/pk/tn 2>/tmp/cron_error.log
# - */5 * * * * /usr/local/bin/duck >/tmp/duck.log 2>/tmp/cron_error.log
# - */30 * * * * /usr/local/bin/pk/gbf 2>/tmp/cron_error.log
# - */2 * * * * export DISPLAY=:0; /usr/local/bin/pk/suspend2safety 2>/tmp/cron_error.log
#
# -------------------------------------------------------------------------------------------
#
# >>> shell rc !
#
# >>> My default configs <<<
#
# - bash: shopt -s histappend extglob checkwinsize
# - zsh: setopt extendedglob; # extended glob
#
# - bash: PS1='\[\033[31m\]\$ \[\033[00m\]'
#
# - unalias -a
# - . ${PK_LOAD_CFGBKP}/rc/shellrc
#
# - cat ~/.cache/current-palette 2>&-
# - feh --bg-scale ~/Pictures/wallpaper/wallpaper.png 2>&-
#
# - trap erease_history EXIT
#
# >>>>>>>>>>>>><<<<<<<<<<<<<
#
# ---------------------------------------------------------------
#
# >>> sudoers !
#
# user ALL=NOPASSWD:/usr/bin/mkdir,/usr/bin/rmdir,/usr/bin/brightnessctl,/usr/bin/mount,/usr/bin/umount,/usr/bin/systemctl suspend
#
##################################################################################################################################

# ********** Declaração de Variáveis **********

# Variáveis principais:
home="${HOME:-/home/${USER:-$(whoami)}}"
hit_log_file=$(mktemp /tmp/init_config_hit_XXXXXXX.log)
error_log_file=$(mktemp /tmp/init_config_error_XXXXXXX.log)
declare -i count_success
declare -a failed_processes
complex_installations='complex_installations'
banner='
    _____   ____________  __________  _   __________________
   /  _/ | / /  _/_  __/ / ____/ __ \/ | / / ____/  _/ ____/
   / //  |/ // /  / /   / /   / / / /  |/ / /_   / // / __
 _/ // /|  // /  / /   / /___/ /_/ / /|  / __/ _/ // /_/ /
/___/_/ |_/___/ /_/____\____/\____/_/ |_/_/   /___/\____/
                 /_____/
'

# Variáveis de caminhos:
local_bin='/usr/local/bin'
bash_file="${home}/.bashrc"
autostart_path="${home}/.config/autostart"
git_path="${home}/Documents/git"

# Variáveis de nomes:
cfg_repo='cfg-bkp'
comandos_repo='linux'

# Arrays
denied_list=(\
	'print_banner' \
	'sudo_validate' \
	'loading_message' \
	'print_blank' \
	'end_message' \
	'default_action' \
	'action_repeater'\
)
folders2create=(\
	${git_path} \
	${autostart_path}\
)
commands=(
	'autostart_programs' \
	'toplip' \
	'speedtest' \
	'yt-dlp' \
	'mdr' \
	'google-chrome' \
	'discord' \
	'code' \
	'subl' \
	'colorpicker' \
	'wdiff' \
	'grive' \
	'setload'\
)

# Variáveis de cores:
green_color='\e[1;32m'
red_color='\e[1;31m'
yellow_color='\e[33m'
bold_effect='\e[1m'
reset_color='\e[m'

# ********** Declaração de Funções **********

# Processo pré instalação: atualização do sistema e instalação dos pacotes via `apt`.
pre_install() {
	default_action
	sudo mkdir -v /usr/local/bin/pk/
	sudo apt update
	sudo apt install \
		                           \
		xorg                       \
		i3                         \
		rofi                       \
		polybar                    \
		dbus-x11                   \
		                           \
		git                        \
		zsh                        \
		terminator                 \
		                           \
		thunar                     \
		copyq                      \
		acpi                       \
		neofetch                   \
		                           \
		highlight                  \
		colordiff                  \
		mousepad                   \
		gnumeric                   \
		abiword                    \
		wdiff                      \
		xclip                      \
		vim                        \
		translate-shell            \
		                           \
		zathura                    \
		                           \
		kolourpaint                \
		mplayer                    \
		yt-dlp                     \
		scrot                      \
		feh                        \
		color-picker               \
		                           \
		pkg-config                 \
		autoconf                   \
		make                       \
		gcc                        \
		build-essential            \
		                           \
		links2                     \
		wget                       \
		curl                       \
		network-manager            \
		                           \
		preload                    \
		gnupg                      \
		unzip                      \
		qt5ct                      \
		zip                        \
		bc                         \
		alsa-utils                 \
		                           \
		ranger                     \
		tree                       \
		progress                   \
		                           \
		libnotify-bin              \
		vim-gtk3                   \
		qt5-style-plugins          \
		                           \
		ubuntu-drivers-common      \
		lsb-release                \
		software-properties-common \
		                           \
	-y
}

# Clona os repositórios padrões e os coloca no diretório padrão.
clone_repos() {
	default_action
	action_repeater git clone "https://github.com/rhuanpk/${comandos_repo}.git" "${git_path}/${comandos_repo}"
	action_repeater git clone "https://github.com/rhuanpk/${cfg_repo}.git" "${git_path}/${cfg_repo}"
}

# Seta o arquivo de configura de rede.
set_network_file() {
	default_action
	sudo tee /etc/netplan/01-netcfg.yaml <<- EOF
		# This file describes the network interfaces available on your system
		# For more information, see netplan(5).
		network:
		  version: 2
		  renderer: NetworkManager
	EOF
}

# Seta o path para o scripts pessoais.
set_personal_path() {
	default_action
	original_path='/usr/local/bin:'
	concatenated_path="${original_path}/usr/local/bin/pk:"
	sudo sed -Ei "s~(${original_path})~${concatenated_path}~" /etc/environment
}

# Seta as variáveis de ambiente *qt* e *PK_LOAD*.
set_environment_variables() {
	default_action
	sudo tee /etc/environment  <<- EOF
		$(cat /etc/environment)
		export QT_QPA_PLATFORMTHEME=qt5ct
		export QT_AUTO_SCREEN_SCALE_FACTOR=0
		export PK_LOAD_CFGBKP=null
		export PK_LOAD_LINUX=null
		export PK_LOAD_PKUTILS=null
	EOF
}

# Seta o arquivo de autostart e o script dos programas do autostart.
set_autostart_programs() {
	default_action
	sudo tee ${local_bin}/autostart_programs  <<- EOF
		#!/usr/bin/env bash

		sleep 5; \$(which copyq) &
		sleep 5; \$(which pcloud) &
		sleep 5; \$(which discord) &
		sleep 5; noti-notify --start
	EOF
	sudo chmod +x ${local_bin}/autostart_programs
	cat <<- EOF > ${autostart_path}/autostart_programs.desktop
		[Desktop Entry]
		Type=Application
		Name=autostart_programs
		Exec=/usr/local/bin/autostart_programs
		StartupNotify=false
		Terminal=false
	EOF
}

# Seta o novo swapfile.
set_swapfile() {
	default_action
	sudo swapoff /swapfile
	sudo rm /swapfile
	sudo fallocate -l 4G /swapfile
	sudo chmod 600 /swapfile
	sudo mkswap /swapfile
	sudo swapon /swapfile
}

# Seta os symlinks necessários.
set_configurations() {
	${git_path}/${cfg_repo}/polybar/symlink-create.sh
	${git_path}/${cfg_repo}/swappiness/configure.sh
	${git_path}/${cfg_repo}/rofi/symlink-create.sh
	${git_path}/${cfg_repo}/setload/configure.sh
	${git_path}/${cfg_repo}/i3/symlink-create.sh
	${git_path}/${cfg_repo}/rc/symlink-create.sh
	${git_path}/${comandos_repo}/scripts/move2symlink.sh
}

# Instala os programas pré compilados.
install_portables() {
	# speedtest
	default_action
	{ action_repeater wget -O ./speedtest.tgz 'https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-x86_64.tgz'; } \
	&& tar -zxvf ./speedtest.tgz \
	&& sudo mv ./speedtest ${local_bin}/
	# toplip
	default_action
	{ action_repeater sudo curl -fsSLo ${local_bin}/toplip 'https://2ton.com.au/standalone_binaries/toplip'; } \
	&& sudo chmod +x ${local_bin}/toplip
	# mdr
	default_action
	{ action_repeater sudo curl -fsSLo ${local_bin}/mdr 'https://github.com/MichaelMure/mdr/releases/latest/download/mdr_linux_amd64'; } \
	&& sudo chmod +x ${local_bin}/mdr
}

# Instala os programas `.deb`.
install_programs() {
	# sublime
	default_action
	action_repeater wget -O - https://download.sublimetext.com/sublimehq-pub.gpg | sudo tee /etc/apt/keyrings/sublimehq-pub.asc >/dev/null
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/sublimehq-pub.asc] https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt update; sudo apt install sublime-text -y
	sudo apt install -fy
	# chrome
	default_action
	action_repeater wget -O ./google-chrome_tmp.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo dpkg -i ./google-chrome_tmp.deb
	sudo apt install -fy
	# discord
	default_action
	action_repeater wget -O ./discord_tmp.deb 'https://discord.com/api/download?platform=linux&format=deb'
	sudo dpkg -i ./discord_tmp.deb
	sudo apt install -fy
	# vscode
	default_action
	action_repeater wget -O - https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/keyrings/packages.microsoft.asc >/dev/null
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/packages.microsoft.asc] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
	sudo apt update; sudo apt install apt-transport-https code -y
	sudo apt install -fy

}

# Compila os programas que são disponibilizados apenas nesse formato.
compile_programs() {
	# variables
	grive=grive
	# grive
	default_action
	sudo apt install git cmake build-essential libgcrypt20-dev libyajl-dev libboost-all-dev libcurl4-openssl-dev libexpat1-dev libcppunit-dev binutils-dev debhelper zlib1g-dev dpkg-dev pkg-config -y
	mkdir ./${grive}/ && cd ./${grive}/
	action_repeater git clone https://github.com/vitalif/grive2 $grive
	cd ./${grive}/
	sudo dpkg-buildpackage -j$(processors2use) --no-sign
	cd ../
	sudo dpkg --install ./*.deb
	cd ../
	# colorpicker
	default_action
	sudo apt install libgtk2.0-dev libgdk3.0-cil-dev libx11-dev libxcomposite-dev libxfixes-dev -y
	action_repeater git clone https://github.com/Jack12816/colorpicker.git
	cd ./colorpicker
	sudo make -j$(processors2use)
	sudo mv ./colorpicker ${local_bin}/
	cd ../
	# i3lock-color
	default_action
	sudo apt install autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev -y
	action_repeater git clone https://github.com/Raymo111/i3lock-color.git
	cd ./i3lock-color
	./install-i3lock-color.sh
	cd ../
}

# Desabilita os serviços desnecessários.
disable_services() {
	default_action
	sudo systemctl disable NetworkManager-wait-online.service
}

# Processo pós instalação: faz a atualização completa do sistema.
pos_install() {
	default_action
	PATH=$(sed -nE 's/PATH="(.*)"/\1/p' /etc/environment)
	sudo cp -v ${git_path}/${comandos_repo}/scripts/.private/setload.sh ${local_bin}/setload
	sudo apt purge kdeconnect imagemagick* -y
	echo 'ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true' | sudo debconf-set-selections
	pleno
	echo 'ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select false' | sudo debconf-set-selections
}

# Executa ações padrões antes de executar cada ação.
default_action() { cd /tmp; sudo -v; }

# Executa a ação passada por uma quantidade de vezes pré definida por questões de conexão (timeout?).
action_repeater() {
	for _ in {0..2}; do
		eval "${*}" && return 0
		sleep 5
	done
	return 7
}

# Retorna a quantidade máxima de processadores para usar.
processors2use() {
	processors=$(nproc)
	[ $processors -eq 1 ] && echo 1 || echo $((${processors}-1))
}

# Primeira parte do programa para validar a senha do usuário.
sudo_validate() {
	read -rsp 'Entre com a senha do usuário [sudo]: ' password
	if ! echo ${password} | sudo -Sv &>/dev/null; then
		echo -e "\n\n${red_color}Error: senha do usuário [sudo] incorreta!${reset_color}\n"
		exit 1
	fi
}

# Printa o banner do script.
print_banner() {
	echo -e "${bold_effect}${banner}${reset_color}"
}

# Printa a mensagem de carregamento do processo atual.
loading_message() {
	y_command="${1}"
	while :; do
		for character in \\ \| \/ \- \\ \| \/ \-; do
			sleep .1
			echo -en " \rExecutando ${yellow_color}${y_command}${reset_color}... ${character}"
		done
	done
}

# Printa a mensagem em branco para limpar a linha corrente.
print_blank() {
	local blank
	for any in $(seq 1 $(tput cols)); do
		blank+=' '
	done
	echo -en "\r${blank}"
}

# Printa a mensagem do final do programa.
end_message() {
	count_errors=${#failed_processes[@]}
	cat <<- eof
		Execuções com sucesso: $count_success
		Execuções com falha: $count_errors

	eof
	[ $count_errors -gt 0 ] && {
		echo 'Processos que falharam:'
		for index in $(seq 0 $((${count_errors}-1))); do
			echo -e "\t- ${failed_processes[${index}]}"
		done
		echo ""
	}
}

# ********** Início do Programa **********

clear; print_banner; sudo_validate

for folder in ${folders2create[@]}; do
	[ ! -d $folder ] && mkdir -vp $folder
done

clear; print_banner
for y_function in pre_install $(echo $(declare -F | awk '{print $3}' | sed -E '/(pre|pos)_install/d')) pos_install; do
	default_action
	[[ ! ${denied_list[*]} =~ (${y_function}) ]] && {
		tee -a $hit_log_file 1>> $error_log_file <<- eof
			---------- $y_function ----------
		eof
		loading_message $y_function &
		if ! $y_function 1>> $hit_log_file 2>> $error_log_file; then
			kill $!
			print_blank
			echo -e "\r>>> ${bold_effect}Falhou${reset_color} -> ${red_color}$y_function${reset_color} !"
			failed_processes[${#failed_processes[@]}]=${y_function}
		else
			kill $!
			print_blank
			echo -e "\r>>> ${bold_effect}Sucesso${reset_color} -> ${green_color}$y_function${reset_color} !"
			let ++count_success
		fi
	}
done
echo ""

end_message

loading_message $complex_installations &
for y_command in ${commands[@]}; do
	if ! type ${y_command} &>/dev/null; then
		error_commands[${#error_commands[@]}]=${y_command}
	fi
done
[ -z ${error_commands} ] && {
	kill $!
	print_blank
	echo -e "\r>>> ${bold_effect}Sucesso${reset_color} -> ${green_color}${complex_installations}${reset_color} !"
} || {
	kill $!
	print_blank
	echo -e "\r>>> ${bold_effect}Falhou${reset_color} -> ${red_color}${complex_installations}${reset_color} !"
	for y_command in ${error_commands[@]}; do
		echo -e "\t- ${y_command}"
	done
	echo -e "Total de aplicativos sem êxito: ${#error_commands[@]}"
}
echo ""
