#!/usr/bin/bash

################################################## ***** Pos Pos Install ***** ###################################################
#
# >>> Manual Setup!
#
# Atual's:
# - pcloud;
# - qt5ct;
# - thunar;
# - touchpad;
# - duckdns;
# - ngrok;
# - pipewire;
# - sshd;
# - arandr;
# - polybar;
# - delta;
# - .bash_history;
# - sources.list;
# - HandleLidSwitch*;
# - wireguard:
# 	- Download connection file;
# 	- Configure `nmcli conn import'.
# - gtk:
# 	- Download themes;
# 	- Set configuration file;
# 	- OBS: manual set for Chrome.
# - xinitrc:
# 	- Set arandr script generated?
#
# Off's:
# - grive2;
# - oh-my-zsh.
#
# --------------------------------------------------------------------------------------------------------------------------------
#
# >>> Crontab!
#
# DISPLAY=:0
# #0 * * * * /usr/local/bin/pk/tn 2>/tmp/cron.log
# */2 * * * * /usr/local/bin/pk/suspend2safety 2>/tmp/cron.log
# */30 * * * * /usr/local/bin/pk/gbf 2>/tmp/cron.log
# */5 * * * * /usr/local/bin/duck >/tmp/duck.log 2>/tmp/cron.log
#
# --------------------------------------------------------------------------------------------------------------------------------
#
# >>> Sudoers!
#
# user ALL=NOPASSWD:/usr/bin/mount,/usr/bin/umount,/usr/bin/mkdir,/usr/bin/rmdir
#
##################################################################################################################################

# ***** Variable Declaration *****

# Main variables:
home="${HOME:-/home/${USER:-$(whoami)}}"

# Log variables:
log_hit="`mktemp /tmp/init-config_hit_XXXXXXX.log`"
log_error="`mktemp /tmp/init-config_error_XXXXXXX.log`"

# Path variables:
path_localbin='/usr/local/bin'
path_autostart="$home/.config/autostart"
path_git="$home/projects/me"
path_polkit='/etc/polkit-1/rules.d'
path_gtk3="$home/.config/gtk-3.0"
path_gtk4="$home/.config/gtk-4.0"
path_profile='/etc/profile.d'

# Name variables:
name_cfgbkp='cfg-bkp'
name_linux='linux'
name_polkit='cron-suspend.rules'
name_profile='init-config.sh'

# Arrays:
array_denieds=(
	'print-banner'
	'sudo-validate'
	'loading-message'
	'print-blank'
	'end-message'
	'default-action'
	'action-repeater'
	'processors2use'
	'set-swapfile'
)
array_folders2create_root=(
	"$path_localbin/pk"
)
array_folders2create_user=(
	"$path_autostart"
	"$path_git"
	"$path_gtk3"
	"$path_gtk4"
)
array_commands=(
	'autostart-programs'
	'toplip'
	'mdr'
	'google-chrome'
	'code'
	'colorpicker'
	'setload'
	#'grive'
)
declare -A array_programs=(
	['google-chrome']='https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
	['vscode']="
		code
		asc
		'https://packages.microsoft.com/keys/microsoft.asc'
		deb [arch=`dpkg --print-architecture`] https://packages.microsoft.com/repos/code stable main
       "
 )

# Formatting variables:
color_green='\e[1;32m'
color_red='\e[1;31m'
color_yellow='\e[33m'
format_bold='\e[1m'
format_reset='\e[m'

# Label variables:
message_complexes='complex-installations'
message_banner='
    _____   ____________    __________  _   __________________
   /  _/ | / /  _/_  __/   / ____/ __ \/ | / / ____/  _/ ____/
   / //  |/ // /  / /_____/ /   / / / /  |/ / /_   / // / __
 _/ // /|  // /  / /_____/ /___/ /_/ / /|  / __/ _/ // /_/ /
/___/_/ |_/___/ /_/      \____/\____/_/ |_/_/   /___/\____/
'
# ***** Function Declarations *****

# Pre instalation processing.
pre-install() {
	get-iface() { sed -nE 's/^#iface (.*) inet.*/\1/p' /etc/network/interfaces; }

	default-action
	sudo tee '/etc/apt/preferences.d/all' <<- EOF
		Package: *
		Pin: release a=stable
		Pin-Priority: 500

		Package: *
		Pin: release a=unstable
		Pin-Priority: 300
	EOF
	sudo tee '/etc/apt/sources.list' <<- EOF
		# stable
		deb http://deb.debian.org/debian/ stable main contrib non-free non-free-firmware
		deb http://security.debian.org/debian-security stable-security main contrib non-free non-free-firmware
		deb http://deb.debian.org/debian/ stable-updates main contrib non-free non-free-firmware

		# unstable
		#deb http://deb.debian.org/debian/ sid main contrib non-free non-free-firmware
	EOF

	default-action
	sudo apt update
	sudo apt install -y network-manager
	sudo sed -i '/primary/,$s/^/#/;s/^##/#/' /etc/network/interfaces
	# verify wpa_supplicant error
	sudo systemctl restart wpa_supplicant networking NetworkManager; sleep 3
	while ! nmcli conn up "$(get-iface)"; do sleep 3; done; sleep 3

	default-action
	sudo apt install \
		polybar                    \
		xorg                       \
		i3                         \
		rofi                       \
		dbus-x11                   \
		                           \
		arandr                     \
		htop                       \
		ssh                        \
		git                        \
		terminator                 \
		                           \
		psmisc                     \
		copyq                      \
		acpi                       \
		tmux                       \
		thunar                     \
		                           \
		fonts-symbola              \
		highlight                  \
		colordiff                  \
		mousepad                   \
		vim-gtk3                   \
		wdiff                      \
		xclip                      \
		krop                       \
		vim                        \
		translate-shell            \
		                           \
		zathura                    \
		                           \
		kolourpaint                \
		flameshot                  \
		mplayer                    \
		yt-dlp                     \
		scrot                      \
		feh                        \
		simplescreenrecorder       \
		                           \
		wget                       \
		curl                       \
		                           \
		firejail                   \
		openvpn                    \
		gnupg                      \
		wireguard                  \
		                           \
		unicode                    \
		unzip                      \
		qt5ct                      \
		zip                        \
		bc                         \
		jq                         \
		preload                    \
		                           \
		pavucontrol                \
		                           \
		ranger                     \
		tree                       \
		progress                   \
		                           \
		resolvconf                 \
		                           \
		libnotify-bin              \
		vim-gtk3                   \
		qt5-style-plugins          \
		                           \
		lsb-release                \
		parallel                   \
		xdotool                    \
		xinput                     \
		ncal                       \
		brightnessctl              \
	-y

	default-action
	sudo systemctl restart wpa_supplicant networking NetworkManager; sleep 3
	while ! nmcli conn down "$(get-iface)"; do sleep 3; done; sleep 3
	while ! nmcli conn up "$(nmcli -t -f NAME conn show | grep -v '^lo')"; do sleep 3; done; sleep 3

	default-action
	sudo apt install \
		pipewire-pulse \
	-y --install-recommends
}

# Clone default repositories and put them into default folders.
git-clone-repos() {
	default-action
	action-repeater git clone "https://github.com/rhuanpk/$name_linux.git" "$path_git/$name_linux"
	action-repeater git clone "https://github.com/rhuanpk/$name_cfgbkp.git" "$path_git/$name_cfgbkp"
}

# Sets personal PATH's.
set-personal-path() {
	default-action
	sudo tee "$path_profile/$name_profile" <<- \EOF
		PATH="/usr/local/bin/pk:$PATH"
	EOF
}

# Sets global wide system variables.
set-environment-variables() {
	default-action
	sudo tee -a /etc/environment <<- \EOF
		QT_QPA_PLATFORMTHEME=qt5ct
		QT_AUTO_SCREEN_SCALE_FACTOR=0
		PK_LOAD_CFGBKP=
		PK_LOAD_LINUX=
		PK_LOAD_PKUTILS=
		EDITOR=vim
	EOF
}

# Sets autostart script.
set-autostart-programs() {
	default-action
	sudo tee "$path_localbin/autostart-programs" <<- \EOF
		#!/usr/bin/bash
		#sleep 5; `which discord` &
		sleep 5; `which pcloud` &
		sleep 5; `which copyq` &
		#sleep 5; `which flameshot` &
		#sleep 5; noti-notify --start
	EOF
	sudo chmod +x "$path_localbin/autostart-programs"
	cat <<- EOF >"$path_autostart/autostart-programs.desktop"
		[Desktop Entry]
		Type=Application
		Name=AutoStart Programs
		Exec=/usr/local/bin/autostart-programs
		StartupNotify=false
		Terminal=false
	EOF
}

# Sets the SWAP File.
set-swapfile() {
	default-action
	sudo swapoff '/swapfile'
	sudo rm '/swapfile'
	sudo fallocate -l 4G '/swapfile'
	sudo chmod 600 '/swapfile'
	sudo mkswap '/swapfile'
	sudo swapon '/swapfile'
}

# Runs symlink scripts.
set-configurations() {
	"$path_git/$name_cfgbkp/rc/symlink-create.sh"
	"$path_git/$name_cfgbkp/i3/symlink-create.sh"
	"$path_git/$name_cfgbkp/polybar/symlink-create.sh"
	"$path_git/$name_cfgbkp/dunst/symlink-create.sh"
	"$path_git/$name_cfgbkp/vimrc/symlink-create.sh"
	"$path_git/$name_cfgbkp/rofi/symlink-create.sh"
	"$path_git/$name_cfgbkp/setload/configure.sh"
	"$path_git/$name_cfgbkp/swappiness/configure.sh"
	"$path_git/$name_linux/scripts/move2symlink.sh"
}

# Sets polkit policies.
set-polkit-rules() {
sudo tee "$path_polkit/$name_polkit" << \EOF
polkit.addRule(function(action, subject) {
	if (subject.user == "user" && (action.id == "org.freedesktop.login1.suspend" || action.id == "org.freedesktop.login1.suspend-multiple-session")) {
		return polkit.Result.YES;
	}
});
EOF
}

# Sets GTK configuration files.
set-gtks-config-files() {
	for folder in "$path_gtk3" "$path_gtk4"; do
		cat <<- EOF > "$folder/settings.ini"
			[Settings]
			gtk-application-prefer-dark-theme = true
			#gtk-theme-name =
			#gtk-font-name =
			#gtk-icon-theme-name =
			gtk-cursor-theme-name = default
		EOF
	done
}

# Sets custom xinitrc.
set-xinitrc() {
	cat <<- EOF >"$home/.xinitrc"
		#!/bin/bash
		# <command> &
		# . <script>
		`sed -E '/(^#|^$)/d' '/etc/X11/xinit/xinitrc'`
	EOF
}

# Install pre-compiled programs.
install-portables() {
	# toplip
	default-action
	{ action-repeater sudo curl -fsSLo $path_localbin/toplip 'https://2ton.com.au/standalone_binaries/toplip'; } \
	&& sudo chmod +x $path_localbin/toplip
	# mdr
	default-action
	{ action-repeater sudo curl -fsSLo $path_localbin/mdr 'https://github.com/MichaelMure/mdr/releases/latest/download/mdr_linux_amd64'; } \
	&& sudo chmod +x $path_localbin/mdr
}

# Install .deb programs.
install-programs() {
	# dependencies of any program to be installed
	local dependencies=(
		'apt-transport-https'
	)
	sudo apt install -y "${dependencies[@]}"
	for program in "${!array_programs[@]}"; do
		default-action
		if [ "$(tr -dc ' ' <<< "${array_programs["$program"]}" | wc -m)" -lt 1 ]; then
			action-repeater wget -O './package.deb' "${array_programs["$program"]}"
			sudo dpkg -i './package.deb'
		else
			local parse="$(sed -zE 's,(\n|^\s+|\s+$),,g;s,\t+,;,g' <<< "${array_programs["$program"]}")"
			local package="$(cut -d';' -f1 <<< "$parse")"
			local key_type="$(cut -d';' -f2 <<< "$parse")"
			local key_url="$(cut -d';' -f3 <<< "$parse")"
			local repo_line="$(cut -d';' -f4- <<< "$parse")"
			if [ "$key_type" = 'asc' ]; then
				action-repeater wget -O - "$key_url" | sudo gpg --dearmor -o "/etc/apt/trusted.gpg.d/$program.gpg"
			elif [ "$key_type" = 'gpg' ]; then
				action-repeater sudo wget -O "/etc/apt/trusted.gpg.d/$program.gpg" "$key_url"
			fi
			sudo tee "/etc/apt/sources.list.d/$program.list" <<< "$repo_line"
			sudo apt update; sudo apt install -y "$package"
		fi
		sudo apt install -fy
	done
}

# Compile the programs that are released only in this format.
compile-programs() {
	# grive2
	#grive=grive
	#default-action
	#sudo apt install -y git cmake build-essential libgcrypt20-dev libyajl-dev libboost-all-dev libcurl4-openssl-dev libexpat1-dev libcppunit-dev binutils-dev debhelper zlib1g-dev dpkg-dev pkg-config
	#mkdir "./$grive/" && cd "./$grive/"
	#action-repeater git clone 'https://github.com/vitalif/grive2' "$grive"
	#cd "./$grive/"
	#sudo dpkg-buildpackage -j`processors2use` --no-sign
	#cd ../
	#sudo dpkg --install ./*.deb
	#cd ../
	# colorpicker
	default-action
	sudo apt install -y libgtk2.0-dev libgdk3.0-cil-dev libx11-dev libxcomposite-dev libxfixes-dev
	action-repeater git clone 'https://github.com/Jack12816/colorpicker.git'
	cd './colorpicker/'
	sudo make -j`processors2use`
	sudo mv './colorpicker' "$path_localbin/"
	cd ../
	# i3lock-color
	default-action
	sudo apt install -y autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev
	action-repeater git clone 'https://github.com/Raymo111/i3lock-color.git'
	cd './i3lock-color/'
	./install-i3lock-color.sh
	cd ../
}

# Disable unecessary services.
disable-services() {
	default-action
	for service in 'ssh' 'NetworkManager-wait-online' 'bluetooth' 'networking'; do
		sudo systemctl disable "$service"
	done
	return 0

}

# Post instalation processing.
post-install() {
	default-action
	[ -r "$path_profile/$name_profile" ] && . "$path_profile/$name_profile"
	sudo cp -v "$path_git/$name_linux/scripts/.private/setload.sh" "$path_localbin/setload"
	echo 'ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true' | debconf-set-selections
	full
	echo 'ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select false' | debconf-set-selections
	sudo apt purge -y vim-tiny*
	sudo timedatectl set-local-rtc 0
}

# Execute standard action before perform each action.
default-action() { cd '/tmp/'; sudo -v; }

# Reexecute the same action some times (for timeout reasons?).
action-repeater() {
	for _ in {0..2}; do
		eval $* && return 0
		sleep 5
	done
	return 1
}

# Returns the max count of processors for use.
processors2use() {
	processors=`nproc`
	[ "$processors" -le 1 ] && echo 1 || echo $(("$processors"-1))
}

# Validates the sudo password.
sudo-validate() {
	read -rsp 'Enter with the user password [sudo]: ' password
	if ! echo "$password" | sudo -Sv &>/dev/null; then
		echo -e "\n\n${color_red}Error: invalid password!$format_reset\n"
		exit 1
	fi
}

# Prints the banner script.
print-banner() {
	echo -e "$format_bold$message_banner$format_reset"
}

# Prints the message of atual process.
loading-message() {
	cmd=$1
	while :; do
		for character in \\ \| \/ \- \\ \| \/ \-; do
			sleep .1
			echo -en " \rExecuting $color_yellow$cmd$format_reset... $character"
		done
	done
}

# Prints the blank mesage to clean atual line.
print-blank() {
	unset blank
	for _ in $(seq 1 `tput cols`); do
		blank+=' '
	done
	echo -en "\r$blank"
}

# Pints the message in ending program.
end-message() {
	count_errors=${#failed_processes[@]}
	cat <<- EOF
		Success executions: $count_success
		Failure executions: $count_errors

	EOF
	[ "$count_errors" -gt 0 ] && {
		echo 'Process that failed:'
		for index in `seq 0 $(($count_errors-1))`; do
			echo -e "\t- ${failed_processes[$index]}"
		done; echo
	}
}

# ***** Program Begin *****

clear; print-banner; sudo-validate

for folder in "${list_folders2create_root[@]}"; do
	[ ! -d "$folder" ] && sudo mkdir -pv "$folder/"
done
for folder in "${list_folders2create_user[@]}"; do
	[ ! -d "$folder" ] && mkdir -pv "$folder/"
done

clear; print-banner
for func in pre-install set-personal-path $(echo `declare -F | awk '{print $3}' | sed -E '/((pre|post)-install)|set-personal-path/d'`) post-install; do
	default-action
	[[ ! "${list_denieds[*]}" =~ "$func" ]] && {
		tee -a "$log_hit" >>"$log_error" <<- EOF
			---------- $func ----------
		EOF
		loading-message "$func" &
		if ! "$func" >>"$log_hit" 2>>"$log_error"; then
			kill "$!"
			print-blank
			echo -e "\r>>> ${format_bold}Failure$format_reset -> $color_red$func$format_reset !"
			FAILED_PROCESSES+=("$func")
		else
			kill "$!"
			print-blank
			echo -e "\r>>> ${format_bold}Success$format_reset -> $color_green$func$format_reset !"
			let ++COUNT_SUCCESS
		fi
	}
done; echo

end-message; loading-message $message_complexes &
for cmd in "${list_commands[@]}"; do
	if ! type "$cmd" &>/dev/null; then
		ERROR_COMMANDS+=("$cmd")
	fi
done
[ -z "$error_commands" ] && {
	kill "$!"
	print-blank
	echo -e "\r>>> ${format_bold}Success$format_reset -> $color_green$message_complexes$format_reset!"
} || {
	kill "$!"
	print-blank
	echo -e "\r>>> ${format_bold}Failure$format_reset -> $color_red$message_complexes$format_reset!"
	for cmd in "${error_commands[@]}"; do
		echo -e "\t- $cmd"
	done
	echo -e "Total of unsuccessful applications: ${#error_commands[@]}"
}; echo
