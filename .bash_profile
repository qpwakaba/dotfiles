if [ -f "$HOME/.local/bash_profile" ]; then
  source "$HOME/.local/bash_profile"
fi
if [ -f "$HOME/.profile" ]; then
  source "$HOME/.profile"
fi
if [ -f "$HOME/.bashrc" ]; then
  source "$HOME/.bashrc"
fi
