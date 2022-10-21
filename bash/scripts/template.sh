#!/bin/bash

# Inspired by: https://betterdev.blog/minimal-safe-bash-script-template/

set -euo pipefail

################################ DOCUMENTATION #################################

HELP_DOC=$(
	cat <<'HELP'

Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] [-f] -p param_value arg1 [arg2...]

Script description here.

Available options:

-h, --help          Print this help and exit
-v, --verbose       Print script debug info
-f, --flag          Some flag description
-p, --param         Some param description

HELP
)

#################################### SETUP #####################################

# START WITH CURRENT WORKING DIR AS SCRIPT DIR
WORKING_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

setup_colors() {
	if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
		NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
	else
		NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
	fi
}

msg() {
	echo >&2 -e "${1-}"
}

die() {
	local msg=$1
	local code=${2-1} # DEFAULT EXIT CODE: 1

	msg "${RED}ERROR:${NOFORMAT}: $msg"
	exit "$code"
}

parse_params() {
	# ASSIGN DEFAULT VALUES
	flag=0
	param=''

	while :; do
		case "${1-}" in
		-h | --help) echo "$HELP_DOC" && exit 0 ;;
		-v | --verbose) set -x ;;
		-f | --flag) flag=1 ;; # example flag
		-p | --param)          # example named parameter
			param="${2-}"
			shift
			;;
		-?*) die "Unknown option: $1" ;;
		*) break ;;
		esac
		shift
	done

	args=("$@")

	# CHECK REQUIRED VALUES
	[[ -z "${param-}" ]] && die "Missing required parameter: param"
	[[ ${#args[@]} -eq 0 ]] && die "Missing script arguments"

	return 0
}

setup_colors
parse_params "$@"

#################################### LOGIC #####################################

# EXAMPLE OF CHANGING WORKING DIRECTORY
WORKING_DIR=$(cd "$WORKING_DIR/.." &>/dev/null && pwd -P)

msg "${RED}Read parameters:${NOFORMAT}"
msg "- working directory: ${WORKING_DIR}"
msg "- flag: ${flag}"
msg "- param: ${param}"
msg "- arguments: ${args[*]-}"
