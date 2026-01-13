#!/bin/sh
MERGE_TOOL="vimdiff"

config_list() {
  set_config merge.tool "$MERGE_TOOL"
}


SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)" || (echo >&2 "SCRIPT_DIR detection failed. Aborted."; exit 1)
. "$SCRIPT_DIR/../lib/shlib.sh"

main() {
  if shlib_command_exists git; then
    set_config() {
      set_config_git "$@"
    }
  else
    echo   >&2 "git command not found"
    echo_n >&2 "Append configurations to .gitconfig directly? [y/n]: "
    if ! shlib_confirm_yn_loop; then
      echo >&2 "Aborted."
      exit 1
    fi
    exec >>"$(find_gitconfig)"

    set_config() {
      key="$1"; shift
      value="$1"; shift

      simulate_git_config_set "$key" "$value"
    }
  fi
  config_list "$@"
}

set_config_git() {
  key="$1"; shift
  value="$1"; shift
  current="$(native_git_config_get "$key" 2>/dev/null)"
  if [ $? -eq 0 ]; then
    if [ "$current" = "$value" ]; then
      # current is already same value
      return 0
    fi

    echo   >&2 "$key is currently '$current'"
    echo_n >&2 "Overwrite to '$value'? [y/N]: "
    if ! shlib_confirm_yn_with_default 'n'; then
      return 1
    fi
  fi
  native_git_config_set "$key" "$value"
}

native_git_config_get() {
  # use legacy syntax
  git config --global --get -- "$1"
}

native_git_config_set() {
  # use legacy syntax
  git config --global -- "$1" "$2"
}

simulate_git_config_set_last_section_subsection=
simulate_git_config_set_append() {
  section_subsection="$1"; shift
  name="$1"; shift
  value="$1"; shift

  if ! [ "$section_subsection" = "$simulate_git_config_set_last_section_subsection" ]; then
    echo "[$section_subsection]"
    simulate_git_config_set_last_section_subsection="$section_subsection"
  fi
  echo "  $name = $value"
}

simulate_git_config_set() {
  key="$1"; shift
  value="$1"; shift

  section="${key%%.*}"
  name="${key##*.}"
  if echo "$key" | grep -sq '^[^.]*\.[^.]*$'; then
    # no subsection
    simulate_git_config_set_append "$section" "$name" "$value"
  else
    subsection="${key%.*}"; subsection="${subsection#*.}"
    simulate_git_config_set_append "$section \"$subsection\"" "$name" "$value"
  fi
}

find_gitconfig() {
  if shlib_environ_exists "GIT_CONFIG_GLOBAL"; then
    echo "$GIT_CONFIG_GLOBAL"
    return 0
  fi
  home="$HOME/.gitconfig"
  xdg="${XDG_CONFIG_HOME:-"$HOME/.config"}/git/config"
  if [ -f "$home" ]; then
    echo "$home"
    return 0
  elif [ -f "$xdg" ]; then
    echo "$xdg"
    return 0
  else
    echo "$home"
    return 0
  fi
}

main "$@"
