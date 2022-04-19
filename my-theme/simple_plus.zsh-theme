user_symbol() {
	[ ${UID} -eq 0 ] && echo '[炎] rhuan-pk #' || echo '[rhuan-pk ツ] $'
}
PROMPT='$(user_symbol) '
