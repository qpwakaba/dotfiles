if ! [[ -v DOTFILES_BASH_PROFILE_LOADED ]]; then
  export DOTFILES_BASH_PROFILE_LOADED=1
fi
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
