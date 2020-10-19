if [ -r /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -r "${HOME}/.bash.d/bashrc" ]; then
	. "${HOME}/.bash.d/bashrc"
fi
