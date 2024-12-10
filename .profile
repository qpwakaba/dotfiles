if ! [[ -v DOTFILES_PROFILE_LOADED ]]; then
  export DOTFILES_PROFILE_LOADED=1

  export WWW_HOME='http://www.google.co.jp/'
  export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:'

  if [ "x$TERM" = "x" ] || [ "x$TERM" = "xlinux" ]; then
    export LANG=C.UTF-8
    export LC_ALL=C.UTF-8
  fi

  if [ -f "$HOME/.local/profile" ]; then
    . $HOME/.local/profile
    export PATH="$DOTFILES_HOME/bin:$PATH"
  fi

  if command -v vim >/dev/null; then
    export EDITOR=vim
  fi

  if ! [[ -v XAUTHORITY ]]; then
    export XAUTHORITY="$HOME/.Xauthority"
  fi
fi
