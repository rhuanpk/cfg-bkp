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
#	- oh-my-zsh;
#	- crontab: backup, backup file;
#		- */30 * * * * /usr/local/bin/pk-pick_bkp_file 2>/tmp/cron_error.log
#		- */2 * * * * /usr/local/bin/pk-suspend_for_safety 2>/tmp/cron_error.log
#	- autostart: copyq;
#	- keybinding: vcontrol, bcontrol;
#	- swapfile;
#	- pcloud;
#	- i3lock-color
#	- colorpicker
#
# ---
#
# echo em '/etc/netplan/01-netcfg.yaml':
#
# # This file describes the network interfaces available on your system
# # For more information, see netplan(5).
# network:
#   version: 2
#   renderer: NetworkManager
#
# ---
#
# desabilitar serviços:
#
# sudo systemctl disable docker.service
#
# OBS: desabilitar do "apache2" e "mysql" também?
# ---
#
# echo em '/etc/environment':
#
# PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/tmp/scripts:${HOME}/others/scripts:${HOME}/others/executables"
# export QT_QPA_PLATFORMTHEME=qt5ct
# export QT_AUTO_SCREEN_SCALE_FACTOR=0
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
brightnessctl \
color-picker \
copyq \
mpv \
mousepad \
progress \
translate-shell \
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
ca-certificates \
apt-transport-https \
gnupg \
lsb-release -y

home_path="/home/${USER}"
git_path="${home_path}/Documents/git"
bash_file="${home_path}/.bashrc"
comandos_repo='comandos-linux'
cfg_repo='cfg-bkp'
local_bin='/usr/local/bin'
executables_path="${home_path}/others/executables"

clone_repos() {
	git clone "https://github.com/rhuan-pk/${comandos_repo}.git" "${git_path}/${comandos_repo}"
	git clone "https://github.com/rhuan-pk/${cfg_repo}.git" "${git_path}/${cfg_repo}"
	${git_path}/${comandos_repo}/standard_scripts/move2symlink.sh
	echo -e "\nsource ${git_path}/${cfg_repo}/rc/zbashrc" >> "${bash_file}"
}

docker_install() {
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
	sudo apt update; sudo apt install \
	docker-ce \
	docker-ce-cli \
	containerd.io \
	docker-compose-plugin -y
}

install_programs() {
	# chrome
	wget -O google-chrome_tmp.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo dpkg -i /tmp/google-chrome_tmp.deb
	# vs-code
	wget -O - https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/keyrings/packages.microsoft.asc >/dev/null
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/packages.microsoft.asc] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
	sudo apt update; sudo apt install code -y
	# sublime
	wget -O - https://download.sublimetext.com/sublimehq-pub.gpg | sudo tee /etc/apt/keyrings/sublimehq-pub.asc >/dev/null
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/sublimehq-pub.asc] https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt update; sudo apt install sublime-text -y
	# discord
	wget -O discord_tmp.deb 'https://discord.com/api/download?platform=linux&format=deb'
	sleep 5
	sudo dpkg -i discord_tmp.deb
	sudo apt install -f -y
}

[ ! -d "${git_path}" ] && {
	mkdir -p "${git_path}" 
	clone_repos
} || clone_repos

[ ! -d "${executables_path}" ] && {
	mkdir "${executables_path}"
	wget "https://2ton.com.au/standalone_binaries/toplip" -P "${executables_path}"
	sudo chmod +x "${executables_path}/toplip"
}

docker_install
install_programs
