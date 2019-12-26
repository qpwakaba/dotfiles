#/bin/sh

DOTPATH=~/dotfiles

for f in .??*
do
  [ "$f" = ".git" ] && continue
  [ "$f" = ".ssh" ] && continue

  ln -snfv "$DOTPATH/$f" "$HOME"/"$f"
done

if ! [ -e "$HOME/.local" ]; then
  mkdir "$HOME/.local"
fi
sed -ie '/^export DOTFILES_HOME=.*$/d' "$HOME/.local/profile"
echo "export DOTFILES_HOME=$(cd "$(dirname "$0")" && echo "$(pwd)")" >>"$HOME/.local/profile"


