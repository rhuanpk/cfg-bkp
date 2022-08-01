#!/usr/bin/env bash

#########################################################################################################################################################################
#
# momento pré interface:
#
# sudo apt install \
# xorg \
# i3 \
# rofi \
# polybar -y
#
# ---
#
# instalar manualmente:
#	- pcloud;
#	- oh-my-zsh;
#	- speedtest
#	- colorpicker
#	- i3lock-color
#	- swapfile;
#	- crontab: backup, backup file;
#		- */30 * * * * /usr/local/bin/pk-pick_bkp_file 2>/tmp/cron_error.log
#		- */2 * * * * /usr/local/bin/pk-suspend_for_safety 2>/tmp/cron_error.log
#	- ly (dm (display manager))
#
# ---
#
# colocar no sudoers.d -> NOPASSWD para systemctl suspend
#
# ---
#
# configurar temas gtk, qt e thunar
#
#########################################################################################################################################################################

cd /tmp; sudo apt update; sudo apt install \
vim \
git \
zsh \
xsel \
xclip \
terminator \
neofetch \
htop \
ncdu \
ranger \
tree \
acpi \
scrot \
ristretto \
zathura \
chafa \
alsa-utils \
brightnessctl \
color-picker \
copyq \
mpv \
mousepad \
ghostwriter \
thunar \
falkon \
progress \
translate-shell \
genius \
default-jdk \
software-properties-common \
netcat \
network-manager \
net-tools \
curl \
wget \
inxi \
hwinfo \
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
ca-certificates \
libnotify-bin \
apt-transport-https \
gnupg \
lsb-release -y

home_path="/home/${USER}"
git_path="${home_path}/Documents/git"
bash_file="${home_path}/.bashrc"
comandos_repo='comandos-linux'
cfg_repo='cfg-bkp'
local_bin='/usr/local/bin'

clone_repos() {
	git clone "https://github.com/rhuan-pk/${comandos_repo}.git" "${git_path}/${comandos_repo}"
	git clone "https://github.com/rhuan-pk/${cfg_repo}.git" "${git_path}/${cfg_repo}"
	${git_path}/${comandos_repo}/standard_scripts/move2symlink.sh
	echo -e "\nsource ${git_path}/${cfg_repo}/rc/zbashrc" >> "${bash_file}"
}

set_network_config_file() {
	cat <<- EOF | sudo tee /etc/netplan/01-netcfg.yaml
		# This file describes the network interfaces available on your system
		# For more information, see netplan(5).
		network:
		  version: 2
		  renderer: NetworkManager
	EOF
}

set_vaiables_2qt() {
	cat <<- EOF | sudo tee /etc/environment
		$(cat /etc/environment)
		export QT_QPA_PLATFORMTHEME=qt5ct
		export QT_AUTO_SCREEN_SCALE_FACTOR=0
	EOF
}

set_autostart_programs() {
	cat <<- EOF | sudo tee /usr/local/bin/autostart_programs
		#!/usr/bin/env bash

		sleep 5; \$(which copyq) &
		sleep 5; \$(which pcloud) &
		sleep 5; \$(which discord) &
	EOF
	sudo chmod +x /usr/local/bin/autostart_programs
	cat <<- EOF > /home/$(whoami)/.config/autostart/autostart_programs.desktop
		[Desktop Entry]
		Type=Application
		Name=autostart_programs
		Exec=/usr/local/bin/autostart_programs
		StartupNotify=false
		Terminal=false
	EOF
}

install_docker() {
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
	sudo apt update; sudo apt install \
	docker-ce \
	docker-ce-cli \
	containerd.io \
	docker-compose-plugin -y
}

install_appimages() {
	# toplip
	sudo curl -fsSLo /usr/local/bin/toplip 'https://2ton.com.au/standalone_binaries/toplip'
	sudo chmod +x /usr/local/bin/toplip
}

install_programs() {
	# chrome
	wget -O google-chrome_tmp.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo dpkg -i /tmp/google-chrome_tmp.deb
	# discord
	wget -O discord_tmp.deb 'https://discord.com/api/download?platform=linux&format=deb'
	sleep 5
	sudo dpkg -i discord_tmp.deb
	sudo apt install -f -y
	# vs-code
	wget -O - https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/keyrings/packages.microsoft.asc >/dev/null
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/packages.microsoft.asc] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
	sudo apt update; sudo apt install code -y
	# sublime
	wget -O - https://download.sublimetext.com/sublimehq-pub.gpg | sudo tee /etc/apt/keyrings/sublimehq-pub.asc >/dev/null
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/sublimehq-pub.asc] https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt update; sudo apt install sublime-text -y
}

disable_services() {
	sudo systemctl disable NetworkManager-wait-online.servic
}

# >>> PROGRAMA <<<

[ ! -d "${git_path}" ] && {
	mkdir -p "${git_path}" 
	clone_repos
} || clone_repos

set_network_config_file
set_vaiables_2qt
set_autostart_programs
# install_docker
install_appimages
install_programs
disable_services
