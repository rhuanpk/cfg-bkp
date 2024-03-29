#!/usr/bin/env bash

##################################################################################################################################
#
# ***** Pos Installations *****
#
# >>> Configuração manual !
#
# - pcloud;
# - grive2;
# - oh-my-zsh;
# - gtk;
# - qt5ct;
# - thunar;
# - touchpad;
#
# -----------------------
#
# >>> Crontab !
#
# - 0 * * * * export DISPLAY=:0; /usr/local/bin/pk/tn 2>/tmp/cron_error.log
# - */5 * * * * /usr/local/bin/duck >/tmp/duck.log 2>/tmp/cron_error.log
# - */30 * * * * /usr/local/bin/pk/gbf 2>/tmp/cron_error.log
# - */2 * * * * export DISPLAY=:0; /usr/local/bin/pk/suspend2safety 2>/tmp/cron_error.log
#
# ---------------------------------------------------------------
#
# >>> Sudoers !
#
# user ALL=NOPASSWD:/usr/bin/mkdir,/usr/bin/rmdir,/usr/bin/brightnessctl,/usr/bin/mount,/usr/bin/umount,/usr/bin/systemctl suspend
#
##################################################################################################################################

# ********** Declaração de Variáveis **********
# Variáveis principais.
user="`id -un 1000`"
home="/home/$user"

# Variáveis de logs.
LOG_HIT="`mktemp /tmp/init_config_hit_XXXXXXX.log`"
LOG_ERROR="`mktemp /tmp/init_config_error_XXXXXXX.log`"

# Variáveis de caminhos.
PATH_LOCALBIN='/usr/local/bin'
PATH_AUTOSTART="$home/.config/autostart"
PATH_GIT="$home/projects/me"

# Variáveis de nomes.
NAME_CFGBKP='cfg-bkp'
NAME_LINUX='linux'

# Arrays.
LIST_DENIEDS=( \
	'print-banner' \
	'sudo-validate' \
	'loading-message' \
	'print-blank' \
	'end-message' \
	'default-action' \
	'action-repeater' \
	'processors2use' \
	'set-swapfile' \
	'set-network-file' \
)
LIST_FOLDERS2CREATE_ROOT=( \
	"$PATH_LOCALBIN/pk" \
)
LIST_FOLDERS2CREATE_USER=( \
	"$PATH_AUTOSTART" \
	"$PATH_GIT" \
)
LIST_COMMANDS=(
	'autostart-programs' \
	'toplip' \
	'mdr' \
	'google-chrome' \
	'code' \
	'colorpicker' \
	'grive' \
	'setload'\
)

# Variáveis de cores.
COLOR_GREEN='\e[1;32m'
COLOR_RED='\e[1;31m'
COLOR_YELLOW='\e[33m'
FORMAT_BOLD='\e[1m'
FORMAT_RESET='\e[m'

# Variáveis de mensagens.
MESSAGE_COMPLEXES='complex-installations'
MESSAGE_BANNER='
    _____   ____________  __________  _   __________________
   /  _/ | / /  _/_  __/ / ____/ __ \/ | / / ____/  _/ ____/
   / //  |/ // /  / /   / /   / / / /  |/ / /_   / // / __
 _/ // /|  // /  / /   / /___/ /_/ / /|  / __/ _/ // /_/ /
/___/_/ |_/___/ /_/____\____/\____/_/ |_/_/   /___/\____/
                 /_____/
'

# ********** Declaração de Funções **********
# Processo de pré instalação: atualização do sistema e instalação dos pacotes via `apt`.
pre-install() {
	default-action
	apt update
	apt install \
		                           \
		polybar                    \
		xorg                       \
		i3                         \
		rofi                       \
		dbus-x11                   \
		                           \
		git                        \
		terminator                 \
		                           \
		copyq                      \
		acpi                       \
		thunar                     \
		                           \
		highlight                  \
		colordiff                  \
		mousepad                   \
		wdiff                      \
		xclip                      \
		vim                        \
		translate-shell            \
		                           \
		zathura                    \
		                           \
		mplayer                    \
		yt-dlp                     \
		scrot                      \
		feh                        \
		kolourpaint                \
		                           \
		wget                       \
		curl                       \
		network-manager            \
		                           \
		preload                    \
		unzip                      \
		qt5ct                      \
		zip                        \
		bc                         \
		pipewire                   \
		                           \
		ranger                     \
		tree                       \
		progress                   \
		                           \
		libnotify-bin              \
		vim-gtk3                   \
		qt5-style-plugins          \
		                           \
		lsb-release                \
		parallel                   \
		brightnessctl              \
		                           \
	-y
}

# Clona os repositórios padrões e coloca-os no diretório padrão.
git-clone-repos() {
	default-action
	action-repeater su "$user" -c \"git clone \'https://github.com/rhuanpk/$NAME_LINUX.git\' \'$PATH_GIT/$NAME_LINUX\'\"
	action-repeater su "$user" -c \"git clone \'https://github.com/rhuanpk/$NAME_CFGBKP.git\' \'$PATH_GIT/$NAME_CFGBKP\'\"
}

# _Seta_ o arquivo de configuração de rede.
set-network-file() {
	default-action
	tee /etc/netplan/01-netcfg.yaml <<- \EOF
		# Made by "init-config" script.
		network:
		  version: 2
		  renderer: NetworkManager
	EOF
}

# _Seta_ o _path_ para o _scripts_ pessoais.
set-personal-path() {
	default-action
	tee '/etc/profile.d/init-config.sh' <<- \EOF
		PATH+=":/usr/local/bin/pk"
	EOF
	#tee -a '/root/.profile' >>"$home/.profile" <<< $'\nPATH+=":/usr/local/bin/pk"'
}

# _Seta_ as variáveis de ambiente _Qt_ e _PK\_LOAD_.
set-environment-variables() {
	default-action
	tee -a /etc/environment <<- \EOF
		export QT_QPA_PLATFORMTHEME=qt5ct
		export QT_AUTO_SCREEN_SCALE_FACTOR=0
		export PK_LOAD_CFGBKP=
		export PK_LOAD_LINUX=
		export PK_LOAD_PKUTILS=
	EOF
}

# _Seta_ o arquivo de **autostart** e o _script_ dos programas dele.
set-autostart-programs() {
	default-action
	tee "$PATH_LOCALBIN/autostart-programs" <<- \EOF
		#!/usr/bin/env sh

		sleep 5; `which flameshot` &
		sleep 5; `which copyq` &
		sleep 5; `which pcloud` &
		#sleep 5; `which discord` &
		sleep 5; noti-notify --start
	EOF
	chmod +x "$PATH_LOCALBIN/autostart-programs"
	su "$user" <<- EOF
		cat <<- eof >"$PATH_AUTOSTART/autostart-programs.desktop"
			[Desktop Entry]
			Type=Application
			Name=AutoStart Programs
			Exec=/usr/local/bin/autostart-programs
			StartupNotify=false
			Terminal=false
		eof
	EOF
}

# _Seta_ o novo **swapfile**.
set-swapfile() {
	default-action
	swapoff '/swapfile'
	rm '/swapfile'
	fallocate -l 4G '/swapfile'
	chmod 600 '/swapfile'
	mkswap '/swapfile'
	swapon '/swapfile'
}

# _Seta_ os _symlinks_ necessários.
set-configurations() {
	su "$user" -c "'$PATH_GIT/$NAME_CFGBKP/rc/symlink-create.sh'"
	su "$user" -c "'$PATH_GIT/$NAME_CFGBKP/i3/symlink-create.sh'"
	su "$user" -c "'$PATH_GIT/$NAME_CFGBKP/polybar/symlink-create.sh'"
	"$PATH_GIT/$NAME_CFGBKP/rofi/symlink-create.sh" -w
	"$PATH_GIT/$NAME_CFGBKP/setload/configure.sh" -w
	"$PATH_GIT/$NAME_CFGBKP/swappiness/configure.sh" -w
	"$PATH_GIT/$NAME_LINUX/scripts/move2symlink.sh" -w
}

# Instala os programas pré compilados.
install-portables() {
	# toplip
	default-action
	{ action-repeater curl -fsSLo $PATH_LOCALBIN/toplip 'https://2ton.com.au/standalone_binaries/toplip'; } \
	&& chmod +x $PATH_LOCALBIN/toplip
	# mdr
	default-action
	{ action-repeater curl -fsSLo $PATH_LOCALBIN/mdr 'https://github.com/MichaelMure/mdr/releases/latest/download/mdr_linux_amd64'; } \
	&& chmod +x $PATH_LOCALBIN/mdr
}

# Instala os programas _.deb_.
install-programs() {
	# goole-chrome
	default-action
	action-repeater wget -O './google-chrome_tmp.deb' 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
	dpkg -i './google-chrome_tmp.deb'
	apt install -fy
	# vscode
	default-action
	action-repeater wget -O - 'https://packages.microsoft.com/keys/microsoft.asc' | gpg --dearmor -o '/etc/apt/trusted.gpg.d/vscode.gpg'
	echo "deb [arch=`dpkg --print-architecture`] https://packages.microsoft.com/repos/code stable main" | tee '/etc/apt/sources.list.d/vscode.list' >/dev/null
	apt update; apt install -y apt-transport-https code
	apt install -fy

}

# Compila os programas que são disponibilizados apenas nesse formato.
compile-programs() {
	# grive2
	grive=grive
	default-action
	apt install -y git cmake build-essential libgcrypt20-dev libyajl-dev libboost-all-dev libcurl4-openssl-dev libexpat1-dev libcppunit-dev binutils-dev debhelper zlib1g-dev dpkg-dev pkg-config
	mkdir "./$grive/" && cd "./$grive/"
	action-repeater git clone 'https://github.com/vitalif/grive2' "$grive"
	cd "./$grive/"
	dpkg-buildpackage -j`processors2use` --no-sign
	cd ../
	dpkg --install ./*.deb
	cd ../
	# colorpicker
	default-action
	apt install -y libgtk2.0-dev libgdk3.0-cil-dev libx11-dev libxcomposite-dev libxfixes-dev
	action-repeater git clone 'https://github.com/Jack12816/colorpicker.git'
	cd './colorpicker/'
	make -j`processors2use`
	mv './colorpicker' "$PATH_LOCALBIN/"
	cd ../
	# i3lock-color
	default-action
	apt install -y autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev
	action-repeater git clone 'https://github.com/Raymo111/i3lock-color.git'
	cd './i3lock-color/'
	./install-i3lock-color.sh
	cd ../
}

# Desabilita os serviços desnecessários.
disable-services() {
	default-action
	systemctl disable NetworkManager-wait-online.service
}

# Processo pós instalação: faz a atualização completa do sistema.
post-install() {
	default-action
	[ -r /etc/profile ] && . /etc/profile
	cp -v "$PATH_GIT/$NAME_LINUX/scripts/.private/setload.sh" "$PATH_LOCALBIN/setload"
	echo 'ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true' | debconf-set-selections
	full -w
	echo 'ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select false' | debconf-set-selections
	apt purge -y vim-tiny*
	systemctl disable bluetooth
}

# Executa ações padrões antes de executar cada ação.
default-action() { cd '/tmp/'; }

# Executa a ação passada por uma quantidade de vezes pré definida por questões de conexão (timeout?).
action-repeater() {
	for _ in {0..2}; do
		eval $* && return 0
		sleep 5
	done
	return 1
}

# Retorna a quantidade máxima de processadores para usar.
processors2use() {
	processors=`nproc`
	[ "$processors" -le 1 ] && echo 1 || echo $(("$processors"-1))
}

# _Printa_ o _banner_ do _script_.
print-banner() {
	echo -e "$FORMAT_BOLD$MESSAGE_BANNER$FORMAT_RESET"
}

# _Printa_ a mensagem de carregamento do processo atual.
loading-message() {
	pcommand=$1
	while :; do
		for character in \\ \| \/ \- \\ \| \/ \-; do
			sleep .1
			echo -en " \rExecutando $COLOR_YELLOW$pcommand$FORMAT_RESET... $character"
		done
	done
}

# _Printa_ a mensagem em branco para limpar a linha corrente.
print-blank() {
	unset blank
	for _ in $(seq 1 `tput cols`); do
		blank+=' '
	done
	echo -en "\r$blank"
}

# _Printa_ a mensagem do final do programa.
end-message() {
	COUNT_ERRORS=${#FAILED_PROCESSES[@]}
	cat <<- EOF
		Execuções com sucesso: $COUNT_SUCCESS
		Execuções com falha: $COUNT_ERRORS

	EOF
	[ "$COUNT_ERRORS" -gt 0 ] && {
		echo 'Processos que falharam:'
		for index in `seq 0 $(($COUNT_ERRORS-1))`; do
			echo -e "\t- ${FAILED_PROCESSES[$index]}"
		done; echo
	}
}

# ********** Início do Programa **********
[ "${UID:-`id -u`}" -ne 0 ] && {
	echo -e "\n${COLOR_RED}Execute o programa estando logado como root!$FORMAT_RESET\n"
	exit 1
}

for folder in "${LIST_FOLDERS2CREATE_ROOT[@]}"; do
	[ ! -d "$folder" ] && mkdir -pv "$folder/"
done
for folder in "${LIST_FOLDERS2CREATE_USER[@]}"; do
	[ ! -d "$folder" ] && su "$user" -c "mkdir -pv '$folder/'"
done

clear; print-banner
for pfunction in pre-install set-personal-path $(echo `declare -F | awk '{print $3}' | sed -E '/((pre|post)-install)|set-personal-path/d'`) post-install; do
	default-action
	[[ ! "${LIST_DENIEDS[*]}" =~ "$pfunction" ]] && {
		tee -a "$LOG_HIT" >>"$LOG_ERROR" <<- EOF
			---------- $pfunction ----------
		EOF
		loading-message "$pfunction" &
		if ! "$pfunction" >>"$LOG_HIT" 2>>"$LOG_ERROR"; then
			kill "$!"
			print-blank
			echo -e "\r>>> ${FORMAT_BOLD}Falhou$FORMAT_RESET -> $COLOR_RED$pfunction$FORMAT_RESET !"
			FAILED_PROCESSES+=("$pfunction")
		else
			kill "$!"
			print-blank
			echo -e "\r>>> ${FORMAT_BOLD}Sucesso$FORMAT_RESET -> $COLOR_GREEN$pfunction$FORMAT_RESET !"
			let ++COUNT_SUCCESS
		fi
	}
done; echo

end-message; loading-message $MESSAGE_COMPLEXES &
for pcommand in "${LIST_COMMANDS[@]}"; do
	if ! type "$pcommand" &>/dev/null; then
		ERROR_COMMANDS+=("$pcommand")
	fi
done
[ -z "$ERROR_COMMANDS" ] && {
	kill "$!"
	print-blank
	echo -e "\r>>> ${FORMAT_BOLD}Sucesso$FORMAT_RESET -> $COLOR_GREEN$MESSAGE_COMPLEXES$FORMAT_RESET !"
} || {
	kill "$!"
	print-blank
	echo -e "\r>>> ${FORMAT_BOLD}Falhou$FORMAT_RESET -> $COLOR_RED$MESSAGE_COMPLEXES$FORMAT_RESET !"
	for pcommand in "${ERROR_COMMANDS[@]}"; do
		echo -e "\t- $pcommand"
	done
	echo -e "Total de aplicativos sem êxito: ${#ERROR_COMMANDS[@]}"
}; echo
