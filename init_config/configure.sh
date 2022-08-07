#!/usr/bin/env bash

#########################################################################################################################################################################
#
# instalar manualmente:
#	- pcloud;
#	- oh-my-zsh;
#	- yt-dlp
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

cd /tmp; sudo apt update; sudo apt install \
xorg \
i3 \
rofi \
polybar \
vim \
terminator \
git \
zsh \
xsel \
xclip \
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
gnumeric \
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
dbus-x11 \
autoconf \
pkg-config \
make \
gcc \
build-essential \
lsb-release -y

home_path="/home/${USER}"
git_path="${home_path}/Documents/git"
bash_file="${home_path}/.bashrc"
comandos_repo='comandos-linux'
cfg_repo='cfg-bkp'
local_bin='/usr/local/bin'
autostart_path="/home/$(whoami)/.config/autostart"
folders2create=(\
	${git_path} \
	${autostart_path}\
)
	
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

set_variables_2qt() {
	cat <<- EOF | sudo tee /etc/environment
		$(cat /etc/environment)
		export QT_QPA_PLATFORMTHEME=qt5ct
		export QT_AUTO_SCREEN_SCALE_FACTOR=0
	EOF
}

set_autostart_programs() {
	cat <<- EOF | sudo tee ${local_bin}/autostart_programs
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

set_swapfile() {
	sudo swapoff /swapfile
	sudo rm /swapfile
	sudo fallocate -l 4G /swapfile
	sudo chmod 600 /swapfile
	sudo mkswap /swapfile
	sudo swapon /swapfile
}

set_symlinks() {
	${git_path}/${cfg_repo}/i3/symlink-create.sh
	${git_path}/${cfg_repo}/rofi/symlink-create.sh
	${git_path}/${cfg_repo}/polybar/symlink-create.sh
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
	sudo curl -fsSLo ${local_bin}/toplip 'https://2ton.com.au/standalone_binaries/toplip'
	sudo chmod +x ${local_bin}/toplip
	# speedtest
	wget -O speedtest.tgz 'https://install.speedtest.net/app/cli/ookla-speedtest-1.1.1-linux-x86_64.tgz'
	tar -zxvf speedtest.tgz
	sudo mv speedtest ${local_bin}/
	# yt-dlp
	sudo curl -fsSLo ${local_bin}/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
	sudo chmod a+rx ${local_bin}/yt-dlp
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

compile_programs() {
	# colorpicker
	sudo apt install libgtk2.0-dev libgdk3.0-cil-dev libx11-dev libxcomposite-dev libxfixes-dev -y
	git clone https://github.com/Jack12816/colorpicker.git
	cd ./colorpicker
	sudo make -j4
	sudo mv ./colorpicker ${local_bin}/
	cd ../
	# i3lock-color
	sudo apt install autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev -y
	git clone https://github.com/Raymo111/i3lock-color.git
	cd ./i3lock-color
	./install-i3lock-color.sh
	cd ../
	# abiword
	sudo apt install libfribidi-dev libglib2.0-dev libwv-dev libxslt1-dev libgio2.0-cil-dev libgtk3.0-cil-dev libgtk-3-dev librsvg2-dev libabiword-3.0 libboost-dev -y
	mkdir ./abiword && cd ./abiword && wget 'http://www.abisource.com/downloads/abiword/3.0.5/source/abiword-3.0.5.tar.gz' && tar -zxvf abiword-3.0.5.tar.gz && cd ./abiword-3.0.5 && ./configure && sudo make -j8 && sudo make install
	cd ../../
}

disable_services() {
	sudo systemctl disable NetworkManager-wait-online.servic
}

# >>> PROGRAMA <<<

for folder in ${folders2create[@]}; do
	[ ! -d ${folder} ] && mkdir -p ${folder}
done

clone_repos
set_network_config_file
set_variables_2qt
set_autostart_programs
set_swapfile
set_symlinks
# install_docker
install_appimages
install_programs
compile_programs
disable_services
pk-pleno
