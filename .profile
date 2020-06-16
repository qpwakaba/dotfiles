export WWW_HOME='http://www.google.co.jp/'

if [ -f "$HOME/.local/profile" ]; then
  . $HOME/.local/profile
  export PATH="$DOTFILES_HOME/bin:$PATH"
fi

if [ -n "$BASH_VERSION" ]; then
  if [ -f "$HOME/.bashrc" ];then
    source "$HOME/.bashrc"
  fi
fi

