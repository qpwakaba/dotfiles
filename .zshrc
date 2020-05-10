
for rcfile in $(find $DOTFILES_HOME/zshrc -type f -not -path '*/\.*'); do
  . $rcfile
done

umask 022

. $HOME/.profile


if [ -f ~/.local/zshrc ]; then
  . ~/.local/zshrc
fi

