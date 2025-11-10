##################################################
#
# >>> Meu tema customizado de exemplo !
#
##################################################
#
# roxo = #B000FF
# ciano = #33CAFF
# vermelho = #FF3A3A
# verde = #00FF66
#
##################################################

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{#E84EFF}\u2718%f"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{#E84EFF}\u2714%f"
prompt_symbol() {
	# echo "\u27a6"
	# echo '➜'
	# echo '›'
	# echo '➢'
	# echo '➞'
	# echo ''
}
user_symbol() {
	[ ${UID} -eq 0 ] && echo '#' || echo '$'
}
PROMPT='%F{#00FF66}%B%n%b@%B%m%b%f:%F{#33AAFF}%B%~%b%f$(git_prompt_info)
$(user_symbol) '
