export DOTFILES_PROFILE_LOADED=1

export WWW_HOME='http://www.yahoo.co.jp/'

if [ "${TERM:-linux}" = "linux" ]; then
  export LANG=C.UTF-8
  export LC_ALL=C.UTF-8
fi

if command -v vim >/dev/null; then
  export EDITOR=vim
fi

if [ "${XAUTHORITY:-}" = "" ]; then
  export XAUTHORITY="$HOME/.Xauthority"
fi

if [ -f "$HOME/.local/profile" ]; then
  . $HOME/.local/profile
fi

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"
DOTFILES_CONFIG_HOME="$XDG_CONFIG_HOME/dotfiles"
. "$DOTFILES_CONFIG_HOME/exports"

if [ -d "$DOTFILES_HOME/bin" ]; then
  export PATH="$DOTFILES_HOME/bin:$PATH"
fi
