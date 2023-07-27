#!/usr/bin/env bash
GIT_URL='https://raw.githubusercontent.com/rhuanpk/linux/master/scripts/.private/setload.sh'
ln -sfv "${PK_LOAD_CFGBKP:-`wget -qO - "$GIT_URL" | bash - 2>&- | grep -F cfg-bkp`}/my-theme"/*.zsh-theme "$HOME/.oh-my-zsh/custom/themes/"
