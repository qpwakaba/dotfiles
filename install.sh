#!/bin/sh

check_commands() (
  requisites=0
  while [ $# -gt 0 ]; do
    if ! command -v "$1" >/dev/null 2>&1; then
      echo >&2 "error: command $1 doesn't exist."
      requisites=1
    fi
    shift
  done
  return $requisites
)

check_commands dirname mkdir sed ln mv cat

SCRIPT_DIR="$(cd -- "$(dirname "$0")" && pwd)" || (echo >&2 'SCRIPT_DIR detection failed.'; exit 1)
. "$SCRIPT_DIR/lib/shlib.sh"

main() {
  echo_n "Do you want to install dotfiles to your environment? [y/N]: "
  if ! shlib_confirm_yn_with_default n; then
    exit 1
  fi

  if ! [ -e "$HOME/.local" ]; then
    mkdir "$HOME/.local"
  fi

  (
    cd "$SCRIPT_DIR" && for f in .*; do
      case "$f" in
        "." | ".." | ".git" | ".ssh" | ".gitignore")
          continue
          ;;
      esac

      backup_if_needed "$f"
      ln -snfv "$SCRIPT_DIR/$f" "$HOME/$f"
    done
  )

  if [ -f "$HOME/.local/profile" ]; then
    sed -i "$HOME/.local/profile" -e '/^export DOTFILES_HOME=.*$/d'
    sed -i "$HOME/.local/profile" -e '
      /^# ==== DOTFILES INSTALL SCRIPT: include dotfiles config exports ====$/ {
        N
        N
        /# ==== DOTFILES INSTALL SCRIPT: (DO NOT EDIT THIS BLOCK) ====$/ d
      }'
  fi

  XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"
  DOTFILES_CONFIG_HOME="$XDG_CONFIG_HOME/dotfiles"
  DOTFILES_CONFIG_EXPORTS="$DOTFILES_CONFIG_HOME/exports"
  mkdir -p "$DOTFILES_CONFIG_HOME"
  if [ -f "$DOTFILES_CONFIG_HOME/exports" ]; then
    sed -e '/^export DOTFILES_HOME=.*$/d' -i "$DOTFILES_CONFIG_EXPORTS"
  fi
  echo "export DOTFILES_HOME=$SCRIPT_DIR" >>"$DOTFILES_CONFIG_EXPORTS"

  echo >>"$HOME/.local/profile" \
"# ==== DOTFILES INSTALL SCRIPT: include dotfiles config exports ====
. '$DOTFILES_CONFIG_EXPORTS'
# ==== DOTFILES INSTALL SCRIPT: (DO NOT EDIT THIS BLOCK) ===="

  for f in $SCRIPT_DIR/setup/*.sh; do
    if ! [ -x "$f" ]; then
      continue
    fi
    echo_n "Do you want to run $(basename "$f")? [Y/n]: "
    if shlib_confirm_yn_with_default y; then
      "$f"
    fi
  done
}

backup_if_needed() {
  if ! [ -e "$HOME/$1" ]; then
    return 0
  elif [ -L "$HOME/$1" ]; then
    unlink "$HOME/$1"
    return 0
  elif [ -d "$HOME/$1" ] || [ -d "$HOME/.local/${1#.}" ]; then
    if mv "$HOME/$1" "$HOME/$1.bak" 2>/dev/null; then
      echo >&2 "warning: move existing $1 to $1.bak$i"
      return 0
    else
      for i in $(seq 20); do
        if mv "$HOME/$1" "$HOME/$1.bak$i" 2>/dev/null; then
          echo >&2 "warning: move existing $1 to $1.bak$i"
          return 0
        fi
      done
    fi
    echo >&2 "error: $HOME/$1 backup failed. Installation aborted."
    exit 1
  elif ! [ -e "$HOME/.local/${1#.}" ]; then
    echo >&2 "warning: move existing $1 to ~/.local/${1#.}"
    mv "$HOME/$1" "$HOME/.local/${1#.}"
    return 0
  elif [ -f "$HOME/.local/${1#.}" ]; then
    echo >&2 "warning: merge $1 to existing ~/.local/${1#.}"
    cat "$HOME/$1" \>\>"$HOME/.local/${1#.}"
    rm -f "$HOME/$1"
  else
    echo >&2 "error: $HOME/$1 backup failed. Installation aborted."
    exit 1
  fi

}

main "$@"
