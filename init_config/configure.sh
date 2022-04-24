#!/usr/bin/env bash

sudo apt update && sudo apt install \
vim \
git \
xclip \
terminator \
software-properties-common \
netcat \
network-manager \
net-tools \
sudo \
curl \
wget -y

home_path="/home/${USER}"
git_path="${home_path}/Documents/git"
bash_file="${home_path}/.bashrc"
comandos_repo='comandos-linux'
cfg_repo='cfg-bkp'
local_bin='/usr/local/bin'

clone_repos() {
	git clone "https://github.com/rhuan-pk/${comandos_repo}.git" "${git_path}/${comandos_repo}"
	git clone "https://github.com/rhuan-pk/${cfg_repo}.git" "${git_path}/${cfg_repo}"
	for index in ${git_path}/${comandos_repo}/standard_scripts/*.sh; do
		sudo cp "${index}" "${local_bin}/pk_$(basename ${index%.sh})"
	done
	echo -e "\n${git_path}/${cfg_repo}/rc/zbashrc" >> "${bash_file}"
}

[ ! -d ${git_path} ] && {
	mkdir -p "${git_path}" 
	clone_repos
} || clone_repos
