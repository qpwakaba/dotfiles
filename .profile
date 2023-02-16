export WWW_HOME='http://www.google.co.jp/'
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:'

if ! [ -v WSL_DISTRO_NAME ] && tty | grep 'tty' >/dev/null 2>/dev/null; then
  export LANG=C
  export LC_ALL=C
fi

if [ -f "$HOME/.local/profile" ]; then
  . $HOME/.local/profile
  export PATH="$DOTFILES_HOME/bin:$PATH"
fi

if command -v vim >/dev/null; then
  export EDITOR=vim
fi

