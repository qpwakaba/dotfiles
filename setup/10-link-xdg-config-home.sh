#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)" || (echo >&2 "SCRIPT_DIR detection failed. Aborted."; exit 1)
. "$SCRIPT_DIR/../lib/shlib.sh"

: "${XDG_CONFIG_HOME:="$HOME/.config"}"

main() (
  DOTFILES_CONFIG_HOME="$SCRIPT_DIR/../config"
  # shellcheck disable=SC2164
  cd "$DOTFILES_CONFIG_HOME"
  # shellcheck disable=SC2181
  if [ $? -ne 0 ]; then
    echo >&2 ""
    exit 1
  fi
  for f in ./* ./.*; do
    case "$f" in
      "./." | "./.." | "./.gitignore")
        continue
        ;;
    esac
    backup_if_needed "$f"
    source_path="$(realpath "$SCRIPT_DIR/../config/$f")"
    ln -snfv "$source_path" "$XDG_CONFIG_HOME/$f"
  done
  
)

backup_if_needed() {
  if ! [ -e "$XDG_CONFIG_HOME/$1" ]; then
    return 0
  elif [ -L "$XDG_CONFIG_HOME/$1" ]; then
    unlink "$XDG_CONFIG_HOME/$1"
    return 0
  elif ! [ -e "$XDG_CONFIG_HOME/$1.bak" ]; then
    mv "$XDG_CONFIG_HOME/$1" "$XDG_CONFIG_HOME/$1.bak"
    return 0
  else
    for i in $(seq 20); do
      if ! [ -e "$XDG_CONFIG_HOME/$1.bak" ]; then
        mv "$XDG_CONFIG_HOME/$1" "$XDG_CONFIG_HOME/$1.bak.$i"
        return 0
      fi
    done
    echo >&2 "error: $HOME/$1 backup failed. Installation aborted."
    exit 1
  fi

}

main "$@"
