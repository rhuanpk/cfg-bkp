#!/bin/bash
if ! grep -qF 'keychain --eval' ~/.profile; then
	tee -a ~/.profile <<- \eof

		if which -s keychain; then eval $(keychain --eval --quiet ); fi
	eof
fi
