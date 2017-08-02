#!/bin/bash

###############################################################################


# This file is part of monitoring-common-shell-library.
#
# monitoring-common-shell-library, a library of shell functions used for
# monitoring plugins like used with (c) Nagios, (c) Icinga, etc.
#
# Copyright (C) 2017, Andreas Unterkircher <unki@netshadow.net>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.


set -u -e -o pipefail  # exit-on-error, error on undeclared variables.

###############################################################################


#
# <Variables>
#

readonly EXIT_OK=0
readonly EXIT_WARNING=1
readonly EXIT_CRITICAL=2
readonly EXIT_UNKNOWN=3

readonly TRUE=true
readonly FALSE=false

# reset variables, just in case...
declare EXIT_NO_DATA_IS_CRITICAL=0
declare EXIT_CODE=0 EXIT_TEXT="" EXIT_PERF=""
declare WARNING="" CRITICAL=""
declare DEBUG= VERBOSE=""
declare UNIT='C' DISK= DISK_TEMP= ZERO=

#
# </Variables>
#


###############################################################################


#
# <Functions>
#
is_debug ()
{
   is_declared DEBUG || return 1;
   [ ! -z "${DEBUG}" ] || return 1;
   [ "x${DEBUG}" != "x0" ] || return 1;

   return 0
} 

#
# debug() outputs only if --debug or -d parameters have been given.
# debug output is sent to STDERR!
#
debug ()
{
   is_debug || return 0;

   echo -e "${FUNCNAME[1]}([${BASH_LINENO[0]}]):\t${1}" >&2
}

#
# fail() prints the fail-text as well as the function and code-line from
# which it was called.
#
fail ()
{
   echo -e "${FUNCNAME[1]}([${BASH_LINENO[0]}]):\t${1}"
}

is_verbose ()
{
   is_declared VERBOSE || return 1;
   [ ! -z "${VERBOSE}" ] || return 1;
   [ "x${VERBOSE}" != "x0" ] || return 1;

   return 0
}

#
# verbose() outputs only if --verbose or -v parameters have been given.
# verbose output is sent to STDERR!
#
verbose ()
{
   is_verbose || return 0;

   echo -e "${FUNCNAME[1]}([${BASH_LINENO[0]}]):\t${1}" >&2
}

#
# is_exit_on_no_data_critical() returns true, if it has been
# choosen, that no-data-available is a critical error.
# otherwise it returns false.
#
is_exit_on_no_data_critical ()
{
   is_declared EXIT_NO_DATA_IS_CRITICAL || return 1
   [ ! -z "${EXIT_NO_DATA_IS_CRITICAL}" ] || return 1
   [ "x${EXIT_NO_DATA_IS_CRITICAL}" != "x0" ] || return 1
   return 0
}

#
# check_requirements() tests for other required tools.
#
check_requirements ()
{
   ( is_declared BASH_VERSINFO && [ ! -z "${BASH_VERSINFO[0]}" ] ) || \
      { fail "Strangle BASH_VERSINFO variable is not (correctly) set!"; exit ${EXIT_CRITICAL}; }

   [ ${BASH_VERSINFO} -ge 4 ] || \
      { fail "BASH version 4 or greater is required!"; return ${EXIT_CRITICAL}; }

   [ ! -z "$(which getopt)" ] || \
      { fail "unable to locate GNU 'getopt' binary!"; return 1; }

   [ ! -z "$(which cat)" ] || \
      { fail "unable to locate 'cat' binary!"; return 1; }

   [ ! -z "$(which bc)" ] || \
      { fail "unable to locate 'bc' binary!"; return 1; }

   return 0
}

get_limit_range ()
{
   [ ! -z "${1}" ] || return 1
   local LIMIT="${1}"

   # for ordinary numbers as limit
   if is_integer $LIMIT || is_float $LIMIT; then
      echo "x ${LIMIT}"
      return 0
   fi

   if ! [[ ${LIMIT} =~ ^(-?[[:digit:]]+[\.[:digit:]]*)?:(-?[[:digit:]]+[\.[:digit:]]*)?$ ]]; then
      fail "That does not look like a limit-range at all! ${LIMIT}"
      return 1
   fi

   if [ -z "${BASH_REMATCH[1]}" ]; then
      LIMIT_MIN="x"
   else
      LIMIT_MIN="${BASH_REMATCH[1]}"
   fi

   if [ -z "${BASH_REMATCH[2]}" ]; then
      LIMIT_MAX="x"
   else
      LIMIT_MAX="${BASH_REMATCH[2]}"
   fi

   echo "${LIMIT_MIN} ${LIMIT_MAX}"
   return 0
}

is_declared ()
{     
   [ $# -ge 1 ] || return 1
   declare -p "$1" &> /dev/null
   return $?
}

is_set ()
{
   #is_declared ${1}" || return 1;
   [ ! -z "${1}" ] || return 1;

   local PARAM
   for PARAM in "${@}"; do
      [ "${PARAM}" != "x" ] || return 1;
   done

   return 0
}

is_match ()
{
   [ ! -z "${1}" ] || return 1

   local RETVAL RESULT

   RETVAL=$(( $(echo "${1}" | bc -ql) ))

   if [ "x${RETVAL}" == "x1" ]; then
      RESULT=0
   elif [ "x${RETVAL}" == "x0" ]; then
      RESULT=1
   else
      fail "unexpected result!"
      exit 1
   fi

   debug "${1} = ${RETVAL} (retval:${RESULT})"
   return $RESULT
}

#
# eval_limits() evaluates the given value against the given
# WARNING and CRITICAL limits.
#
eval_limits ()
{
   [ $# -le 3 ] || { fail "eval_limits() requires at least 3 parameters."; return 1; }
   { [ ! -z "${1}" ] && [ ! -z "${2}" ] && [ ! -z "${3}" ]; } || return 1

   local VALUE="${1}"
   local WARNING="${2}"
   local CRITICAL="${3}"
   local TEXT STATE
   local MATCH

   read WARN_MIN WARN_MAX < <(get_limit_range "${WARNING}")
   read CRIT_MIN CRIT_MAX < <(get_limit_range "${CRITICAL}")

   if [ -z "${WARN_MIN}" ] || [ -z "${WARN_MAX}" ] || \
      [ -z "${CRIT_MIN}" ] || [ -z "${CRIT_MAX}" ]; then
      fail "something went wrong on parsing limits!"
      exit 1
   fi

   debug "WARN limit: min=${WARN_MIN}, max=${WARN_MAX}"
   debug "CRIT limit: min=${CRIT_MIN}, max=${CRIT_MAX}"
   debug "VALUE:      val=${VALUE}"

   #
   # first we check for inside- and outside-ranges
   #
   # inside-range warning
   if is_set ${WARN_MIN} ${WARN_MAX} ${CRIT_MIN} ${CRIT_MAX} && \
      is_match "${WARN_MIN} <= ${WARN_MAX}" && \
      is_match "${VALUE} >= ${WARN_MIN}" && \
      is_match "${VALUE} <= ${WARN_MAX}" &&
      is_match "${CRIT_MIN} <= ${CRIT_MAX}" && \
      is_match "${VALUE} >= ${WARN_MIN}" && \
      is_match "${VALUE} <= ${WARN_MAX}"; then
      TEXT="WARNING"
      STATE=${EXIT_WARNING}
      MATCH="inside-range-match"
   # inside-range critical
   elif is_set ${CRIT_MIN} ${CRIT_MAX} && \
      is_match "${CRIT_MIN} <= ${CRIT_MAX}" && \
      is_match "${VALUE} >= ${CRIT_MIN}" && \
      is_match "${VALUE} <= ${CRIT_MAX}"; then
      TEXT="CRITICAL"
      STATE=${EXIT_CRITICAL}
      MATCH="inside-range-match"
   # outside-range warning
   elif is_set ${WARN_MIN} ${WARN_MAX} && \
      is_match "${WARN_MIN} > ${WARN_MAX}" && { \
      is_match "${VALUE} > ${WARN_MIN}" || \
      is_match "${VALUE} < ${WARN_MAX}"; } &&
      is_match "${CRIT_MIN} > ${CRIT_MAX}" && \
      is_match "${VALUE} < ${CRIT_MIN}" && \
      is_match "${VALUE} > ${CRIT_MAX}"; then
      TEXT="WARNING"
      STATE=${EXIT_WARNING}
      MATCH="outside-range-match"
   # outside-range critical
   elif is_set ${CRIT_MIN} ${CRIT_MAX} && \
      is_match "${CRIT_MIN} > ${CRIT_MAX}" && { \
      is_match "${VALUE} > ${CRIT_MIN}" || \
      is_match "${VALUE} < ${CRIT_MAX}"; }; then
      TEXT="CRITICAL"
      STATE=${EXIT_CRITICAL}
      MATCH="outside-range-match"
   #
   # now we check for greater-than-or-equal (max)
   #
   # greater-than-or-equal (max)
   elif ! is_set ${WARN_MIN} && is_set ${WARN_MAX} && \
      is_match "${VALUE} >= ${WARN_MAX}" &&
      is_match "${VALUE} < ${CRIT_MAX}"; then
      TEXT="WARNING"
      STATE=${EXIT_WARNING}
      MATCH="greater-than-or-equal-match"
   elif ! is_set ${CRIT_MIN} && is_set ${CRIT_MAX} && \
      is_match "${VALUE} >= ${CRIT_MAX}"; then
      TEXT="CRITICAL"
      STATE=${EXIT_CRITICAL}
      MATCH="greater-than-or-equal-match"
   #
   # finally check for less-than-or-equal (min)
   #
   elif ! is_set ${WARN_MAX} && is_set ${WARN_MIN} && \
      is_match "${VALUE} <= ${WARN_MIN}" &&
      is_match "${VALUE} > ${CRIT_MIN}"; then
      TEXT="WARNING"
      STATE=${EXIT_WARNING}
      MATCH="less-than-or-equal-match"
   elif ! is_set ${CRIT_MAX} && is_set ${CRIT_MIN} && \
      is_match "${VALUE} <= ${CRIT_MIN}"; then
      TEXT="CRITICAL"
      STATE=${EXIT_CRITICAL}
      MATCH="less-than-or-equal-match"
   else
      TEXT="OK"
      STATE=${EXIT_OK}
      MATCH="no-match-at-all"
   fi

   debug "RESULT: ${MATCH}, eval'd to ${TEXT}(${STATE})."
   echo "${TEXT}"
   return ${STATE}
}

#
# parse_parameters() uses GNU getopt to parse the given command-line parameters.
#
parse_parameters ()
{
   local TEMP= RETVAL=
   if [ $# -lt 1 ]; then
      fail "Parameters required!"
      echo
      show_help
      exit 1
   fi

   TEMP=$(getopt -n ${FUNCNAME[0]} -o 'w:c:D:u:dhvz' --long 'warning:,critical:,disk:,unit:,debug,verbose,help,zero' -- "${@}")
   RETVAL="${?}"

   if [ "x${RETVAL}" != "x0" ] || [[ "${TEMP}" =~ invalid[[:blank:]]option ]]; then
      fail "error parsing arguments, getopt returned '${RETVAL}'!"
      exit 1
   fi

   verbose "Parameters: ${TEMP}"

   eval set -- "${TEMP}"
   unset -v TEMP

   while true; do
      #ARGSPARSED=1
      case ${1} in
         '-h'|'--help')
            show_help
            exit 0
            ;;
         '-d'|'--debug')
            readonly DEBUG=1
            shift
            continue
            ;;
         '-v'|'--verbose')
            readonly VERBOSE=1
            shift
            continue
            ;;
         '-w'|'--warning')
            readonly WARNING="${2}"
            shift 2
            continue
            ;;
         '-c'|'--critical')
            readonly CRITICAL="${2}"
            shift 2
            continue
            ;;
         '--')
            shift
            break
            ;;
         *)
            echo "Invalid parameter(s)! ${1}"
            echo
            show_help
            exit 1
            ;;
      esac
   done

   #if [ -z "${ARGSPARSED}" ] || [ -z "${MODE}" ]; then
   #   echo "Invalid parameter(s)!"
   #   echo
   #   show_help
   #   exit 1
   #fi
   ! is_set DEBUG || debug "Debugging: enabled"
   ! is_set VERBOSE || verbose "Verbose output: enabled"
   ! is_set WARNING || debug "Warning limit: ${WARNING}"
   ! is_set CRITICAL || debug "Critical limit: ${CRITICAL}"

}

#
# is_range() returns true, if the argument given is in the form of an range.
# otherwise it returns false.
#
is_range ()
{
   [ ! -z "${1}" ] || return 1

   [[ "${1}" =~ ^(-?[[:digit:]]+[\.[:digit:]]*)?:(-?[[:digit:]]+[\.[:digit:]]*)?$ ]] || \
      return 1

   return 0
}

#
# is_integer() returns true, if the given argument is an integer number.
# it also accepts the form :[0-9] (value lower than) and [0-9]: (value
# greater than). otherwise it returns false.
#
is_integer ()
{
   [ ! -z "${1}" ] || return 1
   [[ "${1}" =~ ^-?[[:digit:]]+$ ]] || return 1

   return 0
}

#
# is_float() returns true, if the given argument is a floating point number.
# otherwise it returns false.
#
is_float ()
{
   [ ! -z "${1}" ] || return 1
   [[ "${1}" =~ ^-?[[:digit:]]+\.[[:digit:]]*$ ]] || return 1

   return 0
}

#
# is_valid_limit() performs the checks on the given warning
# and critical values and returns true, if they are. otherwise it
# returns false.
#
is_valid_limit ()
{
   [ ! -z "${1}" ] || return 1

   local LIMIT="${1}"

   # an integer
   if is_integer "${LIMIT}"; then
      return 0
   fi

   # a floating-point number (without exponent...)
   if is_float "${LIMIT}"; then
      return 0
   fi

   # a range
   if is_range "${LIMIT}"; then
      return 0
   fi

   return 1
}

#
# validate_parameters() returns true, if the given command-line parameters are
# valid. otherwise it returns false.
#
validate_parameters ()
{
   if ! is_declared WARNING || [ -z "${WARNING}" ] || \
      ! is_declared CRITICAL || [ -z "${CRITICAL}" ]; then
      fail "warning and critical parameters are mandatory!"
      return 1
   fi

   if ! is_valid_limit "${WARNING}"; then
      fail "warning parameter contains an invalid value!"
      return 1
   fi

   if ! is_valid_limit "${CRITICAL}"; then
      fail "critical parameter contains an invalid value!"
      return 1
   fi

   return 0
}

#
# print_result() outputs the final result as required for (c) Nagios,
# (c) Icinga, etc.
#
print_result ()
{
   # EXIT_TEXT minus 2 characters removes the ", " at the end.
   # EXIT_PERF minus 1 character remove the " " at the end.
   readonly STOP_TIME_PLUGIN="$(date +%s%3N)"

   if [ -z "${EXIT_TEXT}" ]; then
      echo "No hddtemp data available."
      ! is_exit_on_no_data_critical || exit ${EXIT_CRITICAL}
      exit ${EXIT_UNKNOWN}
   fi

   echo "${EXIT_TEXT:0:-2}|${EXIT_PERF:0:-1}"
   exit ${EXIT_CODE}
}

#
# show_help() displays the available parameter options to $0.
#
show_help ()
{
   echo
   cat <<EOF
   -h, --help          ... help
   -r, --realm=arg     ... Kerberos realm to use.
   -k, --keytab=arg    ... keytab to use on authenticating against the KDC.
   -p, --principal=arg ... principal to fetch a ticket-granting-ticket (TGT) for.
   -s, --server=arg    ... KDC to authenticate on.
   -S, --service=arg   ... obtain a ticket for a particular service.
   -d, --debug         ... enable debugging.
   -v, --verbose       ... be verbose.

   -w, --warning=arg   ... warning limit, see below LIMITS section (seconds).
   -c, --critical=arg  ... critical limit, see below LIMITS section (seconds).

LIMITS are given similar to check_procs:

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
   echo
}

cleanup ()
{
   local EXITCODE=$?

   #[ ! -z "${TMPDIR}" ] || exit $EXITCODE;
   #[ -d "${TMPDIR}" ] || exit $EXITCODE;
   #rm -rf ${TMPDIR}

   exit $EXITCODE
}

startup ()
{
   readonly START_TIME_PLUGIN="$(date +%s%3N)"

   #declare -g TMPDIR="$(mktemp -d -p /tmp krbtest.XXXXXX)"
   #[ ! -z "${TMPDIR}" ] || { fail "Failed to create temporary directory in /tmp!"; return 1; }
}

rename_func ()
{
   local SRC_FUNC=$(declare -f ${1})
   local DST_FUNC="$2${DST_FUNC#${1}}"
   eval "${DST_FUNC}"
}

trap cleanup INT QUIT TERM EXIT

#
# </Functions>
#


###############################################################################


#
# <TheActualWorkStartsHere>
#
#check_requirements || \
#   { echo "check_requirements() returned non-zero!"; exit 1; }
#startup || \
#   { echo "startup() returned non-zero!"; exit 1; }
#parse_parameters "${@}" || \
#   { echo "parse_parameters() returned non-zero!"; exit 1; }
#validate_parameters || \
#   { echo "validate_parameters() returned non-zero!"; exit 1; }
#print_result ||  \
#   { echo "print_result() returned non-zero!"; exit 1; }

#
# normally our script should have exited in print_result() already.
# so we should not get to this end at all.
# Anyway we exit with $EXIT_UNKNOWN in case.
#
#exit $EXIT_UNKNOWN

#
# </TheActualWorkStartsHere>
#
