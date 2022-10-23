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
	'pre_install' \
	'install_docker'\
	'pos_install' \
	'print_banner' \
	'loading_message' \
	'end_message'\
)
folders2create=(\
	${git_path} \
	${autostart_path}\
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
	cd /tmp
	echo ${password} | sudo -S apt update
	echo ${password} | sudo -S apt install \
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
	-y
}

# Clona os repositórios padrões e os coloca no diretório padrão.
clone_repos() {
	git clone "https://github.com/rhuan-pk/${comandos_repo}.git" "${git_path}/${comandos_repo}"
	git clone "https://github.com/rhuan-pk/${cfg_repo}.git" "${git_path}/${cfg_repo}"
	${git_path}/${comandos_repo}/standard_scripts/move2symlink.sh
	echo -e "\nsource ${git_path}/${cfg_repo}/rc/zbashrc" >> "${bash_file}"
}

# Seta o arquivo de configura de rede.
set_network_file() {
	echo ${password} | sudo -S tee /etc/netplan/01-netcfg.yaml <<- EOF
		# This file describes the network interfaces available on your system
		# For more information, see netplan(5).
		network:
		  version: 2
		  renderer: NetworkManager
	EOF
}

# Seta as variáveis de ambiente do `qt`.
set_variables_2qt() {
	echo ${password} | sudo -S tee /etc/environment  <<- EOF
		$(cat /etc/environment)
		export QT_QPA_PLATFORMTHEME=qt5ct
		export QT_AUTO_SCREEN_SCALE_FACTOR=0
	EOF
}

# Seta o arquivo de autostart e o script dos programas do autostart.
set_autostart_programs() {
	echo ${password} | sudo -S tee ${local_bin}/autostart_programs  <<- EOF
		#!/usr/bin/env bash

		sleep 5; \$(which copyq) &
		sleep 5; \$(which pcloud) &
		sleep 5; \$(which discord) &
	EOF
	echo ${password} | sudo -S chmod +x ${local_bin}/autostart_programs
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
	echo ${password} | sudo -S swapoff /swapfile
	echo ${password} | sudo -S rm /swapfile
	echo ${password} | sudo -S fallocate -l 4G /swapfile
	echo ${password} | sudo -S chmod 600 /swapfile
	echo ${password} | sudo -S mkswap /swapfile
	echo ${password} | sudo -S swapon /swapfile
}

# Seta os symlinks necessários.
set_symlinks() {
	${git_path}/${cfg_repo}/i3/symlink-create.sh
	${git_path}/${cfg_repo}/rofi/symlink-create.sh
	${git_path}/${cfg_repo}/polybar/symlink-create.sh
}

# Instala o docker (depreciado).
install_docker() {
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | echo ${password} | sudo -S gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | echo ${password} | sudo -S tee /etc/apt/sources.list.d/docker.list >/dev/null
	echo ${password} | sudo -S apt update; echo ${password} | sudo -S apt install \
	docker-ce \
	docker-ce-cli \
	containerd.io \
	docker-compose-plugin -y
}

# Instala os programas pré compilados.
install_portables() {
	# toplip
	echo ${password} | sudo -S curl -fsSLo ${local_bin}/toplip 'https://2ton.com.au/standalone_binaries/toplip'
	echo ${password} | sudo -S chmod +x ${local_bin}/toplip
	# speedtest
	wget -O speedtest.tgz 'https://install.speedtest.net/app/cli/ookla-speedtest-1.1.1-linux-x86_64.tgz'
	tar -zxvf speedtest.tgz
	echo ${password} | sudo -S mv speedtest ${local_bin}/
	# yt-dlp
	echo ${password} | sudo -S curl -fsSLo ${local_bin}/yt-dlp 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp'
	echo ${password} | sudo -S chmod +x ${local_bin}/yt-dlp
	# mdr
	echo ${password} | sudo -S curl -fsSLo ${local_bin}/mdr 'https://github.com/MichaelMure/mdr/releases/download/v0.2.5/mdr_linux_amd64'
	echo ${password} | sudo -S chmod +x ${local_bin}/mdr
}

# Instala os programas `.deb`.
install_programs() {
	# chrome
	wget -O google-chrome_tmp.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	echo ${password} | sudo -S dpkg -i /tmp/google-chrome_tmp.deb
	echo ${password} | sudo -S apt install -f -y
	# discord
	wget -O discord_tmp.deb 'https://discord.com/api/download?platform=linux&format=deb'
	sleep 5
	echo ${password} | sudo -S dpkg -i discord_tmp.deb
	echo ${password} | sudo -S apt install -f -y
	# vs-code
	wget -O - https://packages.microsoft.com/keys/microsoft.asc | echo ${password} | sudo -S tee /etc/apt/keyrings/packages.microsoft.asc >/dev/null
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/packages.microsoft.asc] https://packages.microsoft.com/repos/code stable main" | echo ${password} | sudo -S tee /etc/apt/sources.list.d/vscode.list >/dev/null
	echo ${password} | sudo -S apt update; echo ${password} | sudo -S apt install code -y
	echo ${password} | sudo -S apt install -f -y
	# sublime
	wget -O - https://download.sublimetext.com/sublimehq-pub.gpg | echo ${password} | sudo -S tee /etc/apt/keyrings/sublimehq-pub.asc >/dev/null
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/sublimehq-pub.asc] https://download.sublimetext.com/ apt/stable/" | echo ${password} | sudo -S tee /etc/apt/sources.list.d/sublime-text.list
	echo ${password} | sudo -S apt update; echo ${password} | sudo -S apt install sublime-text -y
	echo ${password} | sudo -S apt install -f -y
}

# Compila os programas que são disponibilizados apenas nesse formato.
compile_programs() {
	local abiword=abiword
	local grive2=grive2
	# colorpicker
	echo ${password} | sudo -S apt install libgtk2.0-dev libgdk3.0-cil-dev libx11-dev libxcomposite-dev libxfixes-dev -y
	git clone https://github.com/Jack12816/colorpicker.git
	cd ./colorpicker
	echo ${password} | sudo -S make -j8
	echo ${password} | sudo -S mv ./colorpicker ${local_bin}/
	cd ../
	# i3lock-color
	echo ${password} | sudo -S apt install autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev -y
	git clone https://github.com/Raymo111/i3lock-color.git
	cd ./i3lock-color
	./install-i3lock-color.sh
	cd ../
	# wdiff
	echo ${password} | sudo -S apt install texinfo colordiff -y
	mkdir ./${wdiff}/ && cd ./${wdiff}/ && curl -Lo ${wdiff}.tar.gz 'http://ftp.gnu.org/gnu/wdiff/wdiff-latest.tar.gz' && tar -zxvf ./${wdiff}.tar.gz && cd $(ls -1 | grep -E "(${wdiff}-([[:digit:]]+\.?)+)") && echo ${password} | sudo -S ./configure && echo ${password} | sudo -S make -j8 && echo ${password} | sudo -S make install
	cd ../../
	# grive2
	echo ${password} | sudo -S apt install git cmake build-essential libgcrypt20-dev libyajl-dev libboost-all-dev libcurl4-openssl-dev libexpat1-dev libcppunit-dev binutils-dev debhelper zlib1g-dev dpkg-dev pkg-config -y
	mkdir ./${grive2}/ && cd ./${grive2}/
	git clone 'https://github.com/vitalif/grive2' $grive2
	cd ./${grive2}/
	dpkg-buildpackage -j8 --no-sign
	cd ../
	echo ${password} | sudo -S dpkg --install ./*.deb
	cd ../
}

# Desabilita os serviços desnecessários.
disable_services() {
	echo ${password} | sudo -S systemctl disable NetworkManager-wait-online.service
}

pos_install() {
	echo $password | sudo -Sv
	pk-pleno
}

# Printa a mensagem de carregamento do processo atual.
loading_message() {
	y_command="${1}"
	while :; do
		for character in \\ \| \/ \- \\ \| \/ \-; do
			sleep .1
			echo -en " \rExecutando ${yellow_color}${y_command}${reset_color} ... ${character}"
		done
	done
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

print_banner() {
	echo -e "${bold_effect}${banner}${reset_color}"
}

# ********** Início do Programa **********	

clear

print_banner
read -rsp 'Entre com a senha do usuário [echo ${password} | sudo -S]: ' password
if ! echo ${password} | sudo -S -Sv; then
	echo -e "${red_color}Error: senha do usuário [echo ${password} | sudo -S] incorreta!${reset_color}"
	exit 1
fi

for folder in ${folders2create[@]}; do
	[ ! -d $folder ] && mkdir -vp $folder
done
for any in $(seq 1 $(tput cols)); do
	blank+=' '
done

clear

print_banner
for y_function in pre_install $(declare -F | awk '{print $3}') pos_install; do
	[[ ! ${denied_list[*]} =~ (${y_function}) ]] && {
		tee -a $hit_log_file 1>> $error_log_file <<- eof
			---------- $y_function ----------
		eof
		loading_message $y_function &
		if ! $y_function 1>> $hit_log_file 2>> $error_log_file; then
			kill $!
			echo -en "\r${blank}"
			echo -e "\r>>> ${bold_effect}Falhou${reset_color} -> ${red_color}$y_function${reset_color} !"
			failed_processes[${#failed_processes[@]}]=${y_function}
		else
			kill $!
			echo -en "\r${blank}"
			echo -e "\r>>> ${bold_effect}Sucesso${reset_color} -> ${green_color}$y_function${reset_color} !"
			let ++count_success
		fi
	}
done
echo ""

end_message
