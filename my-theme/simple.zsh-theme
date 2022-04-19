user_symbol() {
	[ ${UID} -eq 0 ] && echo '#' || echo '$'
}
PROMPT='$(user_symbol) '
