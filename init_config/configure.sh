#!/usr/bin/env bash

# manualmente: instalar zsh e oh-my-zsh; crontab: backup, backup file; autostart: copyq; vcontrol, bcontrol; swapfile
# programas: pcloud, eclipse, netbeans

cd /tmp; sudo apt update; sudo apt install \
vim \
git \
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
brightnessctl \
color-picker \
copyq \
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
	echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.asc] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
	sudo apt update; sudo apt install code -y
	# sublime
	wget -O - https://download.sublimetext.com/sublimehq-pub.gpg | sudo tee /etc/apt/keyrings/sublimehq-pub.asc >/dev/null
	echo "deb [signed-by=/etc/apt/keyrings/sublimehq-pub.asc] https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
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

[ ! -d "${executables_path}" ] && mkdir "${executables_path}"

wget "https://2ton.com.au/standalone_binaries/toplip" -P "${executables_path}"
sudo chmod +x "${executables_path}/toplip"

docker_install
install_programs
