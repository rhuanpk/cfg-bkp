# function "get_symbol" pick the "X"

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY="✱"
ZSH_THEME_GIT_PROMPT_CLEAN="✔"

get_symbol() {
	echo "\u2718"
}

user_symbol() {
	if [ ${UID} -eq 0 ] && echo '#' || echo '$'
}

user_name() {
	if [ ${UID} -eq 0 ] && echo "%B%S%F{magenta}%n%f%s%b" || echo "%B%F{cyan}%n%f%b"
}

PROMPT='$(user_name)%F{red}$(get_symbol)%f%B%F{cyan}$(hostname)%f%b%F{red}:%f%B%F{magenta}%0~%f%b $(git_prompt_info)%F{red}$(user_symbol)%f '

