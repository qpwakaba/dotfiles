export WWW_HOME='http://www.google.co.jp/'
if tty | grep 'tty' >/dev/null 2>/dev/null; then
  export LANG=C
  export LC_ALL=C
fi

if [ -f "$HOME/.local/profile" ]; then
  . $HOME/.local/profile
  export PATH="$DOTFILES_HOME/bin:$PATH"
fi

alias ":tmux-reload"="tmux source-file ~/.tmux.conf"
alias ":tmux-attach"="tmux attach-session"
alias ":tmux-detach"="sudo -k; tmux detach-client"
alias ":tmux-display"="export $(tmux show-env | grep ^DISPLAY=)"

alias ":shell-reload"="exec $SHELL"

alias "detach"=":tmux-detach"

