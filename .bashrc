if ! [[ -v DOTFILES_BASHRC_LOADED ]]; then
  DOTFILES_BASHRC_LOADED=1

  if [ -f "${XDG_CONFIG_HOME:-"$HOME/.config"}/dotfiles/exports" ]; then
    source "${XDG_CONFIG_HOME:-"$HOME/.config"}/dotfiles/exports"
  fi
  source "$DOTFILES_HOME/rc"
  for rcfile in $(find $DOTFILES_HOME/bashrc -type f -not -path '*/\.*'); do
    source "$rcfile"
  done

  umask 022

  if [ -f ~/.local/bashrc ]; then
    source ~/.local/bashrc
  fi
fi
