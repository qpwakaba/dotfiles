if ! [[ -v DOTFILES_BASH_PROFILE_LOADED ]]; then
  export DOTFILES_BASH_PROFILE_LOADED=1
fi
source "$HOME/.profile"
if [ -f "$HOME/.bashrc" ]; then
  source "$HOME/.bashrc"
fi
