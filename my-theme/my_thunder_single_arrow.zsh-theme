user_symbol() {
	if [ ${UID} -eq 0 ] && echo '#' || echo '$'
}

PROMPT='%F{#ff0033}$(hostname) ››%f '

