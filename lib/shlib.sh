#!/bin/sh

# echo -n
echo_n() {
  printf "%s" "$1"
}

# returns specified command is executable
shlib_command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# read from stdin y or n
# exit code: 'y' => 0, 'n' => 1, '' => 3, * => 2
shlib_confirm_yn() {
  case "$(read _; echo "$_")" in
    "y" | "Y")
      return 0
      ;;
    "n" | "N")
      return 1
      ;;
    "")
      return 3
      ;;
    *)
      return 2
      ;;
  esac
}

# read from stdin y or n
# exit code: 'y' => 0, 'n' => 1
# any other input => echo -n "input y or n: "
shlib_confirm_yn_loop() {
  while :; do
    shlib_confirm_yn
    case $? in
      0)
        return 0
        ;;
      1)
        return 1
        ;;
      *)
        echo_n 'input y or n: '
        ;;
    esac
  done
}

# read from stdin y, n or any other input
# $1: default answer 'y' or 'n'
# exit code: 'y' => 0, 'n' => 1, * => 2
shlib_confirm_yn_with_default() {
  shlib_confirm_yn
  case $? in
    0)
      return 0
      ;;
    1)
      return 1
      ;;
    3)
      echo "$1" | shlib_confirm_yn
      return
      ;;
    *)
      return $?
      ;;
  esac
}

# $1: variable name
# exit code: 0 => environ variable exists, 1 => not exists
shlib_environ_exists() {
  sh -c 'export' | while IFS=' =' read _ name value; do
    if [ "$name" = "$1" ]; then
      return 0
    fi
  done
  return 1
}

# vim: set ft=sh :
