export WWW_HOME='http://www.google.co.jp/'

if [ -f "$HOME/.local/profile" ]; then
  . $HOME/.local/profile
  export PATH="$DOTFILES_HOME/bin:$PATH"
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'

