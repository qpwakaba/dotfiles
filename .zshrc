
if [ -f "${XDG_CONFIG_HOME:-"$HOME/.config"}/dotfiles/exports" ]; then
  source "${XDG_CONFIG_HOME:-"$HOME/.config"}/dotfiles/exports"
fi
source "$DOTFILES_HOME/rc"
for rcfile in $(find $DOTFILES_HOME/zshrc -type f -not -path '*/\.*'); do
  . "$rcfile"
done

umask 022



if [ -f ~/.local/zshrc ]; then
  . ~/.local/zshrc
fi

