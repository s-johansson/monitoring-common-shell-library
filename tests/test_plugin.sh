#!/bin/bash

###############################################################################


# This file is part of the monitoring-common-shell-library.
#
# monitoring-common-shell-library, a library of shell functions used for
# monitoring plugins like used with (c) Nagios, (c) Icinga, etc.
#
# Copyright (C) 2017-2018, Andreas Unterkircher <unki@netshadow.net>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.


set -u -e -o pipefail # exit-on-error, error on undeclared variables.
#shopt -s sourcepath  # in case Bash won't consider $PATH.

###############################################################################

# shellcheck disable=SC1091
source ../functions.sh

[ "x${?}" == "x0" ] || \
   { fail "unable to include 'functions.sh'!"; exit 1; }

if [ $# -ge 1 ] && [ "${1}" == "-n" ]; then
   DO_NOT_RUN=true
   shift
fi

#
# <Variables>
#

DEBUG=1
readonly PROGNAME="$(basename "${0}")"
readonly VERSION="1.0"

declare -g TMPDIR='' STATE_FILE=''
# shellcheck disable=SC2034
declare -g -a WELL_KNOWN_KEYS=(
   'counter'
   'crit'
   'label'
   'max'
   'min'
   'type'
   'unit'
   'value'
   'warn'
)
declare -g -A RESULTS=()


#
# </Variables>
#

add_param '-H:' --host: HOST localhost
add_param '-p:' --port: PORT 5665
add_param '-f:' --file: FILE
add_param '-i:' --input: INPUT

set_help_text <<EOF
${PROGNAME}, v${VERSION}

   -h, --help         ... help
   -v, --verbose      ... be more verbose.
   -d, --debug        ... enable debugging.
   -f, --file         ... use file as input instead of querying API

   -w, --warning=arg  ... warning threshold, see below THRESHOLDS section.
   -c, --critical=arg ... critical threshold, see below THRESHOLDS section.

API:

   -H, --host=arg     ... hostname, fqdn or address of the host
                          (default: localhost)
   -p, --port=arg     ... numeric port-number of the server
                          (default: 5665)

THRESHOLDS are given similar to check_procs:

   * greater-than-or-equal-match (max) results in warning on:
      --warning :4
      --warning 4
   * less-than-or-equal-match (min) results in warning on:
      --warning 4:
   * inside-range-match (min:max)
      --warning 5:10
   * outside-range-match (max:min)
      --warning 10:5
EOF


###############################################################################


#
# <Functions>
#

# @function plugin_params_validate()
# @brief This functions validates the provided command-line parameters and
# returns 0, if the given arguments are valid. otherwise it returns 1.
# @return int
plugin_params_validate ()
{
   has_param_value FILE && \
      debug "File: $(get_param_value FILE)"
   has_param_value HOST && \
      debug "Host: $(get_param_value HOST)"
   has_param_value PORT && \
      debug "Port: $(get_param_value PORT)"
   has_param_value INPUT && \
      debug "Input: $(get_param_value INPUT)"

   if ! has_param_value HOST || ! [[ "$(get_param_value HOST)" =~ ^[[:graph:]]+$ ]]; then
      fail "Invalid hostname provided. Allowed are only alpha-numeric and punctation characters!"
      return 1
   fi

   if ! has_param_value PORT || ! [[ "$(get_param_value PORT)" =~ ^[[:digit:]]+$ ]]; then
      fail "Invalid port provided. Allowed are only numeric characters!"
      return 1
   fi

   return 0
}

# @function plugin_worker()
# @brief An example implementation.
# @return int
plugin_worker ()
{
   add_prereq cat

   has_param INPUT || return 1
   has_param_value INPUT || return 1
   local INPUT='' KEY='' VAL=''
   local -A COUPLE=()

   INPUT="$(get_param_value INPUT)"
   ! is_empty "${INPUT}" || return 1

   IFS=, read -r -a INPUT_ARY <<< "${INPUT}"

   for COUPLE in "${INPUT_ARY[@]}"; do
      [[ "${COUPLE}" =~ ^([[:graph:]]+)=([[:graph:]]+)$ ]] || continue
      KEY="${BASH_REMATCH[1]}"
      VAL="${BASH_REMATCH[2]}"

      add_result "${KEY}" "${VAL}"
   done

   if is_func "user_eval_results"; then
      user_eval_results || \
         { fail "user_eval_results() returned non-zero! Exiting."; exit 1; }
      return $?
   fi

   eval_results || \
      { fail "eval_results() returned non-zero! Exiting."; exit 1; }

   return $?
}

# @function plugin_startup()
# @brief This function gets invoked by the monitoring-common-shell-library.
# In our case, it requests a temporary directory from the library and installs
# a cleanup trap, that tries to ensure, that any residues in the filesystem get
# removed.
# @return int
plugin_startup ()
{
   TMPDIR="$(create_tmpdir)"
   setup_cleanup_trap;

   [ ! -z "${TMPDIR}" ] || { fail "Failed to create temporary directory in /tmp!"; return 1; }
}

#
# </Functions>
#

#
# <TheActualWorkStartsHere>
#
! [[ -v DO_NOT_RUN ]] || return 0
startup "${@}"


#
# normally our script should have exited in print_result() already.
# so we should not get to this end at all.
# Anyway we exit with $CSL_EXIT_UNKNOWN in case.
#
exit "${CSL_EXIT_UNKNOWN}"

#
# </TheActualWorkStartsHere>
#
