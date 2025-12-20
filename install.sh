#/usr/bin/env bash

DOTPATH=~/dotfiles
(cd $DOTPATH && git submodule update --init --recursive)

if ! [ -e "$HOME/.local" ]; then
  mkdir "$HOME/.local"
fi

for f in .??*
do
  [ "$f" = ".git" ] && continue
  [ "$f" = ".ssh" ] && continue

  if [ -f "$HOME/$f" -a ! -L "$HOME/$f" ]; then
    mv "$HOME/$f" "$HOME/.local/${f#.}"
  fi
  ln -snfv "$DOTPATH/$f" "$HOME"/"$f"
done

if [ -f "$HOME/.local/profile" ]; then
  sed -e '/^export DOTFILES_HOME=.*$/d' -i "$HOME/.local/profile"
fi

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"
DOTFILES_CONFIG_HOME="$XDG_CONFIG_HOME/dotfiles"
mkdir -p "$DOTFILES_CONFIG_HOME"
if [ -f "$DOTFILES_CONFIG_HOME/exports" ]; then
  sed -e '/^export DOTFILES_HOME=.*$/d' -i "$DOTFILES_CONFIG_HOME/exports"
fi
echo "export DOTFILES_HOME=$(cd "$(dirname "$0")" && echo "$(pwd)")" >>"$DOTFILES_CONFIG_HOME/exports"


