#!/bin/sh
: "${NPM_USERENV_PREFIX:="$HOME/.local/npm"}"


SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)" || (echo >&2 "SCRIPT_DIR detection failed. Aborted."; exit 1)
. "$SCRIPT_DIR/../lib/shlib.sh"

main() {
  if shlib_command_exists npm; then
    npm config set prefix "$NPM_USERENV_PREFIX"
  else
    echo "prefix = $NPM_USERENV_PREFIX" >>"$(find_npmrc)"
  fi
}

find_npmrc() {
  if [ -n "$NPM_CONFIG_USERCONFIG" ]; then
    echo "$NPM_CONFIG_USERCONFIG"
    return 0
  fi
  echo "$HOME/.npmrc"
  return 0
}

main "$@"
