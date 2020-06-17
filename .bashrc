if [ -z "$DOTFILES_HOME" ]; then
  NOT_LOAD_BASHRC=true
  source ~/.profile
  return
fi

for rcfile in $(find $DOTFILES_HOME/bashrc -type f -not -path '*/\.*'); do
  source $rcfile
done

umask 022

if [ -f ~/.local/bashrc ]; then
  source ~/.local/bashrc
fi

