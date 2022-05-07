[ ${UID} -eq 0 ] && { name="[炎] $(whoami)"; symbol='#'; color=red ;} || { name="[$(whoami) ツ]"; symbol='$'; color=cyan ;}
PROMPT='%F{${color}}${name}%f ${symbol} '
