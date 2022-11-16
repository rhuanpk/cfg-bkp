#!/usr/bin/env bash

#########################################################################################################################################################################
#
# instalar manualmente:
#	- pcloud;
#	- oh-my-zsh;
#	- crontab: backup, backup file;
# 		- 0 * * * * export DISPLAY=:0; /usr/local/bin/pk-todo_notify 2>/tmp/cron_error.log
#		- */30 * * * * /usr/local/bin/pk-pick_bkp_file 2>/tmp/cron_error.log
#		- */2 * * * * export DISPLAY=:0; /usr/local/bin/pk-suspend_for_safety 2>/tmp/cron_error.log
#	- ly (dm (display manager))
#
# ---
#
# colocar no sudoers.d -> NOPASSWD para systemctl suspend
#
# ---
#
# configurar temas gtk, qt e thunar, touchpad
#
#########################################################################################################################################################################
		
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
comandos_repo='comandos-linux'

# Arrays
denied_list=(\
	'install_docker'\
	'print_banner' \
	'sudo_validate' \
	'loading_message' \
	'print_blank' \
	'end_message'\
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
	sudo -v
	sudo apt update
	sudo apt install \
		xorg \
		i3 \
		rofi \
		polybar \
		vim \
		vim-gtk \
		terminator \
		git \
		zsh \
		xclip \
		neofetch \
		htop \
		ncdu \
		ranger \
		tree \
		acpi \
		scrot \
		okular \
		pdfgrep \
		zathura \
		feh \
		photoflare \
		libimage-exiftool-perl \
		alsa-utils \
		brightnessctl \
		color-picker \
		python3-pygments \
		highlight \
		copyq \
		moc \
		mplayer \
		mousepad \
		abiword \
		gnumeric \
		thunar \
		wkhtmltopdf \
		pdftk \
		progress \
		translate-shell \
		genius \
		colordiff \
		software-properties-common \
		netcat \
		network-manager \
		curl \
		wget \
		inxi \
		hwinfo \
		cpu-x \
		mtools \
		qt5ct \
		qt5-style-plugins \
		zip \
		unzip \
		p7zip-full \
		p7zip-rar \
		unrar \
		pandoc \
		lynx \
		links2 \
		preload \
		libnotify-bin \
		gnupg \
		dbus-x11 \
		autoconf \
		pkg-config \
		make \
		gcc \
		build-essential \
		lsb-release \
		ubuntu-drivers-common \
	-y
}

# Clona os repositórios padrões e os coloca no diretório padrão.
clone_repos() {
	git clone "https://github.com/rhuan-pk/${comandos_repo}.git" "${git_path}/${comandos_repo}"
	git clone "https://github.com/rhuan-pk/${cfg_repo}.git" "${git_path}/${cfg_repo}"
}

# Seta o arquivo de configura de rede.
set_network_file() {
	sudo -v
	sudo tee /etc/netplan/01-netcfg.yaml <<- EOF
		# This file describes the network interfaces available on your system
		# For more information, see netplan(5).
		network:
		  version: 2
		  renderer: NetworkManager
	EOF
}

# Seta as variáveis de ambiente do `qt`.
set_environment_variables() {
	sudo -v
	sudo tee /etc/environment  <<- EOF
		$(cat /etc/environment)
		export QT_QPA_PLATFORMTHEME=qt5ct
		export QT_AUTO_SCREEN_SCALE_FACTOR=0
		export PK_LOAD_CFGBKP=null
		export PK_LOAD_LINUXCOMMANDS=null
		export PK_LOAD_PKUTILS=null
	EOF
}

# Seta o arquivo de autostart e o script dos programas do autostart.
set_autostart_programs() {
	sudo -v
	sudo tee ${local_bin}/autostart_programs  <<- EOF
		#!/usr/bin/env bash

		sleep 5; \$(which copyq) &
		sleep 5; \$(which pcloud) &
		sleep 5; \$(which discord) &
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
	sudo -v
	sudo swapoff /swapfile
	sudo rm /swapfile
	sudo fallocate -l 4G /swapfile
	sudo chmod 600 /swapfile
	sudo mkswap /swapfile
	sudo swapon /swapfile
}

# Seta os symlinks necessários.
set_configurations() {
	${git_path}/${cfg_repo}/i3/symlink-create.sh
	${git_path}/${cfg_repo}/rofi/symlink-create.sh
	${git_path}/${cfg_repo}/polybar/symlink-create.sh
	${git_path}/${cfg_repo}/setload/configure.sh
	${git_path}/${comandos_repo}/standard_scripts/move2symlink.sh
}

# Instala o docker (depreciado).
install_docker() {
	sudo -v
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
	sudo apt update; sudo apt install \
	docker-ce \
	docker-ce-cli \
	containerd.io \
	docker-compose-plugin -y
}

# Instala os programas pré compilados.
install_portables() {
	sudo -v
	# toplip
	sudo curl -fsSLo ${local_bin}/toplip 'https://2ton.com.au/standalone_binaries/toplip'
	sudo chmod +x ${local_bin}/toplip
	# speedtest
	wget -O speedtest.tgz 'https://install.speedtest.net/app/cli/ookla-speedtest-1.1.1-linux-x86_64.tgz'
	tar -zxvf speedtest.tgz
	sudo mv speedtest ${local_bin}/
	# yt-dlp
	sudo curl -fsSLo ${local_bin}/yt-dlp 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp'
	sudo chmod +x ${local_bin}/yt-dlp
	# mdr
	sudo curl -fsSLo ${local_bin}/mdr 'https://github.com/MichaelMure/mdr/releases/download/v0.2.5/mdr_linux_amd64'
	sudo chmod +x ${local_bin}/mdr
}

# Instala os programas `.deb`.
install_programs() {
	sudo -v
	# chrome
	wget -O google-chrome_tmp.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo dpkg -i /tmp/google-chrome_tmp.deb
	sudo apt install -f -y
	# discord
	wget -O discord_tmp.deb 'https://discord.com/api/download?platform=linux&format=deb'
	sleep 5
	sudo dpkg -i discord_tmp.deb
	sudo apt install -f -y
	# vs-code
	wget -O - https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/keyrings/packages.microsoft.asc >/dev/null
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/packages.microsoft.asc] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
	sudo apt update; sudo apt install code -y
	sudo apt install -f -y
	# sublime
	wget -O - https://download.sublimetext.com/sublimehq-pub.gpg | sudo tee /etc/apt/keyrings/sublimehq-pub.asc >/dev/null
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/sublimehq-pub.asc] https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt update; sudo apt install sublime-text -y
	sudo apt install -f -y
}

# Compila os programas que são disponibilizados apenas nesse formato.
compile_programs() {
	sudo -v
	local wdiff=wdiff
	local grive2=grive2
	# colorpicker
	sudo apt install libgtk2.0-dev libgdk3.0-cil-dev libx11-dev libxcomposite-dev libxfixes-dev -y
	git clone https://github.com/Jack12816/colorpicker.git
	cd ./colorpicker
	sudo make -j8
	sudo mv ./colorpicker ${local_bin}/
	cd ../
	# i3lock-color
	sudo apt install autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev -y
	git clone https://github.com/Raymo111/i3lock-color.git
	cd ./i3lock-color
	./install-i3lock-color.sh
	cd ../
	# wdiff
	sudo apt install texinfo colordiff -y
	mkdir ./${wdiff}/ && cd ./${wdiff}/ && curl -Lo ${wdiff}.tar.gz 'http://ftp.gnu.org/gnu/wdiff/wdiff-latest.tar.gz' && tar -zxvf ./${wdiff}.tar.gz && cd $(ls -1 | grep -E "(${wdiff}-([[:digit:]]+\.?)+)") && sudo ./configure && sudo make -j8 && sudo make install
	cd ../../
	# grive2
	sudo apt install git cmake build-essential libgcrypt20-dev libyajl-dev libboost-all-dev libcurl4-openssl-dev libexpat1-dev libcppunit-dev binutils-dev debhelper zlib1g-dev dpkg-dev pkg-config -y
	mkdir ./${grive2}/ && cd ./${grive2}/
	git clone 'https://github.com/vitalif/grive2' $grive2
	cd ./${grive2}/
	dpkg-buildpackage -j8 --no-sign
	cd ../
	sudo dpkg --install ./*.deb
	cd ../
}

# Desabilita os serviços desnecessários.
disable_services() {
	sudo -v
	sudo systemctl disable NetworkManager-wait-online.service
}

# Processo pós instalação: faz a atualização completa do sistema.
pos_install() {
	sudo -v
	echo -e $'\nsource $PK_LOAD_CFGBKP/rc/zbashrc' >> "${bash_file}"
	sudo cp -v ${git_path}/${comandos_repo}/standard_scripts/.pessoal/setload.sh ${local_bin}/setload
	echo 'ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true' | sudo debconf-set-selections
	pk-pleno
	echo 'ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select false' | sudo debconf-set-selections
	sudo apt purge kdeconnect kded5 -y
}

# Primeira parte do programa para validar a senha do usuário
sudo_validate() {
	read -rsp 'Entre com a senha do usuário [sudo]: ' password
	if ! echo ${password} | sudo -Sv &>/dev/null; then
		echo -e "\n\n${red_color}Error: senha do usuário [sudo] incorreta!${reset_color}\n"
		exit 1
	fi
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

# Printa a mensagem em branco para limpar a linha corrente
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

# Printa o banner do script
print_banner() {
	echo -e "${bold_effect}${banner}${reset_color}"
}

# ********** Início do Programa **********	

cd /tmp
clear
print_banner
sudo_validate

for folder in ${folders2create[@]}; do
	[ ! -d $folder ] && mkdir -vp $folder
done
clear
print_banner
for y_function in pre_install $(echo $(declare -F | awk '{print $3}' | sed -E '/(pre|pos)_install/d')) pos_install; do
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
	if ! which ${y_command} &>/dev/null; then
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
