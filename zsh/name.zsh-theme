[ ${UID:-$(id -u)} -eq 0 ] && { name="[炎] root"; symbol='#'; color=red ;} || { name="rhuan-pk ツ"; symbol='$'; color=cyan ;}
PROMPT='%F{${color}}${name}%f ${symbol} '
