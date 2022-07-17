. $HOME/.profile

source "$DOTFILES_HOME/rc"
for rcfile in $(find $DOTFILES_HOME/zshrc -type f -not -path '*/\.*'); do
  . $rcfile
done

umask 022



if [ -f ~/.local/zshrc ]; then
  . ~/.local/zshrc
fi

