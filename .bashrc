source ~/.profile

for rcfile in $(find $DOTFILES_HOME/bashrc -type f -not -path '*/\.*'); do
  source $rcfile
done

umask 022

if [ -f ~/.local/bashrc ]; then
  source ~/.local/bashrc
fi

