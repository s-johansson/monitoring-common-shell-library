#!/bin/bash

###############################################################################


# This file is part of monitoring-common-shell-library v1.1.
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

readonly CSL_EXIT_OK=0
readonly CSL_EXIT_WARNING=1
readonly CSL_EXIT_CRITICAL=2
readonly CSL_EXIT_UNKNOWN=3

readonly CSL_TRUE=true
readonly CSL_FALSE=false

# reset variables, just in case...
declare -g CSL_EXIT_NO_DATA_IS_CRITICAL=0
declare -g CSL_EXIT_CODE=0 CSL_EXIT_TEXT= CSL_EXIT_PERF=
declare -g CSL_WARNING_LIMIT= CSL_CRITICAL_LIMIT=
declare -g CSL_DEBUG= CSL_VERBOSE=
declare -g CSL_DEFAULT_HELP_TEXT= CSL_HELP_TEXT=
declare -g CSL_GETOPT_SHORT= CSL_GETOPT_LONG=

readonly CSL_DEFAULT_GETOPT_SHORT='w:c:dhv'
readonly CSL_DEFAULT_GETOPT_LONG='warning:,critical:,debug,verbose,help'

readonly -a CSL_DEFAULT_PREREQ=( 'getopt' 'cat' 'bc' 'mktemp' )
declare -a CSL_USER_PREREQ=()

declare -a CSL_TEMP_DIRS=()
declare -A CSL_USER_GETOPT_PARAMS=()

# the '&& true' is required as read exits non-zero on reaching end-of-file
read -r -d '' CSL_DEFAULT_HELP_TEXT <<'EOF' && true
   -h, --help          ... help
   -d, --debug         ... enable debugging.
   -v, --verbose       ... be verbose.

   -w, --warning=arg   ... warning limit, see below LIMITS section.
   -c, --critical=arg  ... critical limit, see below LIMITS section.

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
readonly CSL_DEFAULT_HELP_TEXT

#
# </Variables>
#


###############################################################################


#
# <Functions>
#
is_debug ()
{
   is_declared CSL_DEBUG || return 1;
   ! is_empty "${CSL_DEBUG}" || return 1;
   [ "x${CSL_DEBUG}" != "x0" ] || return 1;

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
   is_declared CSL_VERBOSE || return 1;
   ! is_empty "${CSL_VERBOSE}" || return 1;
   [ "x${CSL_VERBOSE}" != "x0" ] || return 1;

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
   is_declared CSL_EXIT_NO_DATA_IS_CRITICAL || return 1
   ! is_empty "${CSL_EXIT_NO_DATA_IS_CRITICAL}" || return 1
   [ "x${CSL_EXIT_NO_DATA_IS_CRITICAL}" != "x0" ] || return 1
   return 0
}

#
# check_requirements() tests for other required tools.
#
check_requirements ()
{
   # is Bash actually used?
   ( is_declared BASH_VERSINFO && ! is_empty "${BASH_VERSINFO[0]}" ) || \
      { fail "Strangle BASH_VERSINFO variable is not (correctly) set!"; exit ${CSL_EXIT_CRITICAL}; }

   # Bash major version 4 or later is required
   [ ${BASH_VERSINFO[0]} -ge 4 ] || \
      { fail "BASH version 4.3 or greater is required!"; return ${CSL_EXIT_CRITICAL}; }

   # If bash major version 4 is used, the minor needs to be 3 or greater (for [[ -v ]] tests).
   ( [ ${BASH_VERSINFO[0]} -eq 4 ] && [ ${BASH_VERSINFO[1]} -ge 3 ] ) || \
      { fail "BASH version 4.3 or greater is required!"; return ${CSL_EXIT_CRITICAL}; }

   local PREREQ

   for PREREQ in "${CSL_DEFAULT_PREREQ[@]}" "${CSL_USER_PREREQ[@]}"; do
      is_cmd "${PREREQ}" || { fail "Unable to locate '${PREREQ}' binary!"; return 1; }
   done

   return 0
}

get_limit_range ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty "${1}" || return 1
   local LIMIT="${1}"

   # for ordinary numbers as limit
   if is_integer "${LIMIT}" || is_float "${LIMIT}"; then
      echo "x ${LIMIT}"
      return 0
   fi

   if ! [[ ${LIMIT} =~ ^(-?[[:digit:]]+[\.[:digit:]]*)?:(-?[[:digit:]]+[\.[:digit:]]*)?$ ]]; then
      fail "That does not look like a limit-range at all!"
      return 1
   fi

   local LIMIT_MIN="x"
   if ! is_empty "${BASH_REMATCH[1]}"; then
      LIMIT_MIN="${BASH_REMATCH[1]}"
   fi

   local LIMIT_MAX="x"
   if ! is_empty "${BASH_REMATCH[2]}"; then
      LIMIT_MAX="${BASH_REMATCH[2]}"
   fi

   echo "${LIMIT_MIN} ${LIMIT_MAX}"
   return 0
}

is_declared ()
{
   [ $# -eq 1 ] || return 1
   declare -p "${1}" &> /dev/null
   return $?
}

is_declared_func ()
{
   [ $# -eq 1 ] || return 1
   declare -p -f "${1}" &> /dev/null
   return $?
}

is_set ()
{
   [ $# -ge 1 ] || return 1

   local PARAM
   for PARAM in "${@}"; do
      [ "${PARAM}" != "x" ] || return 1;
   done

   return 0
}

is_empty ()
{
   [ $# -eq 1 ] || return 1
   [ -z "${1}" ] || return 1

   return 0
}

is_match ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty "${1}" || return 1

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

is_dir ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty "${1}" || return 1
   [ -d "${1}" ] || return 1

   return 0
}

#
# eval_limits() evaluates the given value against the given
# CSL_WARNING_LIMIT and CSL_CRITICAL_LIMIT limits.
#
eval_limits ()
{
   [ $# -eq 3 ] || \
      { fail "eval_limits() requires 3 parameters."; return 1; }

   ( ! is_empty "${1}" && ! is_empty "${2}" && ! is_empty "${3}" ) || return 1

   local VALUE="${1}"
   local WARNING="${2}" WARN_MIN= WARN_MAX=
   local CRITICAL="${3}" CRIT_MIN= CRIT_MAX=
   local TEXT= STATE= MATCH=

   read -r WARN_MIN WARN_MAX < <(get_limit_range "${WARNING}")
   read -r CRIT_MIN CRIT_MAX < <(get_limit_range "${CRITICAL}")

   if is_empty "${WARN_MIN}" || is_empty "${WARN_MAX}" || \
      is_empty "${CRIT_MIN}" || is_empty "${CRIT_MAX}"; then
      fail "something went wrong on parsing limits!"
      exit 1
   fi

   debug "WARN thres: min=${WARN_MIN}, max=${WARN_MAX}"
   debug "CRIT thres: min=${CRIT_MIN}, max=${CRIT_MAX}"
   debug "VALUE:      val=${VALUE}"

   #
   # first we check for inside- and outside-ranges
   #
   # inside-range warning
   #
   if is_set ${WARN_MIN} ${WARN_MAX} ${CRIT_MIN} ${CRIT_MAX} && \
      is_match "${WARN_MIN} <= ${WARN_MAX}" && \
      is_match "${VALUE} >= ${WARN_MIN}" && \
      is_match "${VALUE} <= ${WARN_MAX}" &&
      is_match "${CRIT_MIN} <= ${CRIT_MAX}" && \
      is_match "${VALUE} >= ${WARN_MIN}" && \
      is_match "${VALUE} <= ${WARN_MAX}"; then
      TEXT="WARNING"
      STATE=${CSL_EXIT_WARNING}
      MATCH="inside-range-match"
   #
   # inside-range critical
   #
   elif is_set ${CRIT_MIN} ${CRIT_MAX} && \
      is_match "${CRIT_MIN} <= ${CRIT_MAX}" && \
      is_match "${VALUE} >= ${CRIT_MIN}" && \
      is_match "${VALUE} <= ${CRIT_MAX}"; then
      TEXT="CRITICAL"
      STATE=${CSL_EXIT_CRITICAL}
      MATCH="inside-range-match"
   #
   # outside-range warning
   #
   elif is_set ${WARN_MIN} ${WARN_MAX} && \
      is_match "${WARN_MIN} > ${WARN_MAX}" && { \
      is_match "${VALUE} > ${WARN_MIN}" || \
      is_match "${VALUE} < ${WARN_MAX}"; } &&
      is_match "${CRIT_MIN} > ${CRIT_MAX}" && \
      is_match "${VALUE} < ${CRIT_MIN}" && \
      is_match "${VALUE} > ${CRIT_MAX}"; then
      TEXT="WARNING"
      STATE=${CSL_EXIT_WARNING}
      MATCH="outside-range-match"
   #
   # outside-range critical
   #
   elif is_set ${CRIT_MIN} ${CRIT_MAX} && \
      is_match "${CRIT_MIN} > ${CRIT_MAX}" && { \
      is_match "${VALUE} > ${CRIT_MIN}" || \
      is_match "${VALUE} < ${CRIT_MAX}"; }; then
      TEXT="CRITICAL"
      STATE=${CSL_EXIT_CRITICAL}
      MATCH="outside-range-match"
   #
   # now we check for greater-than-or-equal (max)
   #
   # greater-than-or-equal (max)
   #
   elif ! is_set ${WARN_MIN} && is_set ${WARN_MAX} && \
      is_match "${VALUE} >= ${WARN_MAX}" &&
      is_match "${VALUE} < ${CRIT_MAX}"; then
      TEXT="WARNING"
      STATE=${CSL_EXIT_WARNING}
      MATCH="greater-than-or-equal-match"
   elif ! is_set ${CRIT_MIN} && is_set ${CRIT_MAX} && \
      is_match "${VALUE} >= ${CRIT_MAX}"; then
      TEXT="CRITICAL"
      STATE=${CSL_EXIT_CRITICAL}
      MATCH="greater-than-or-equal-match"
   #
   # finally check for less-than-or-equal (min)
   #
   elif ! is_set ${WARN_MAX} && is_set ${WARN_MIN} && \
      is_match "${VALUE} <= ${WARN_MIN}" &&
      is_match "${VALUE} > ${CRIT_MIN}"; then
      TEXT="WARNING"
      STATE=${CSL_EXIT_WARNING}
      MATCH="less-than-or-equal-match"
   elif ! is_set ${CRIT_MAX} && is_set ${CRIT_MIN} && \
      is_match "${VALUE} <= ${CRIT_MIN}"; then
      TEXT="CRITICAL"
      STATE=${CSL_EXIT_CRITICAL}
      MATCH="less-than-or-equal-match"
   else
      TEXT="OK"
      STATE=${CSL_EXIT_OK}
      MATCH="no-match-at-all"
   fi

   if is_empty "${MATCH}" || is_empty "${TEXT}" || is_empty "${STATE}"; then
      fail "something went horribly wrong."
      exit 1
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
   local GETOPT_SHORT="${CSL_DEFAULT_GETOPT_SHORT}"
   local GETOPT_LONG="${CSL_DEFAULT_GETOPT_LONG}"

   if [ $# -lt 1 ]; then
      fail "Parameters required!"
      echo
      show_help
      exit 1
   fi

   if has_short_params; then
      TEMP=$(get_short_params)

      if ! is_empty "${TEMP}"; then
         GETOPT_SHORT+="${TEMP}"
      fi
   fi

   if has_long_params; then
      TEMP=$(get_long_params)

      if ! is_empty "${TEMP}" ; then
         GETOPT_LONG+=",${TEMP}"
      fi
   fi

   TEMP=$(getopt -n ${FUNCNAME[0]} -o "${GETOPT_SHORT}" --long "${GETOPT_LONG}" -- "${@}")
   RETVAL="${?}"

   if [ "x${RETVAL}" != "x0" ] || \
     is_empty "${TEMP}" || \
     [[ "${TEMP}" =~ invalid[[:blank:]]option ]]; then

      fail "error parsing arguments, getopt returned '${RETVAL}'!"
      exit 1
   fi

   debug "Parameters: ${TEMP}"

   # add the parsed parameters back to the positional parameters.
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
            readonly CSL_DEBUG=1
            shift
            continue
            ;;
         '-v'|'--verbose')
            readonly CSL_VERBOSE=1
            shift
            continue
            ;;
         '-w'|'--warning')
            readonly CSL_WARNING_LIMIT="${2}"
            shift 2
            continue
            ;;
         '-c'|'--critical')
            readonly CSL_CRITICAL_LIMIT="${2}"
            shift 2
            continue
            ;;
         '--')
            shift
            break
            ;;
         *)
            if is_empty "${1}"; then
               shift
               continue
            fi

            local USER_OPT="${1}" USER_FUNC= USER_ARG= SHIFT=1

            if ! [[ "${USER_OPT}" =~ ^-?-?([[:alnum:]]+)$ ]]; then
               echo "Invalid parameter! ${USER_OPT}"
               show_help
               exit 1
            fi

            USER_OPT="${BASH_REMATCH[1]}"

            if ! is_declared CSL_USER_GETOPT_PARAMS || \
               ! [[ -v CSL_USER_GETOPT_PARAMS[${USER_OPT}] ]]; then
               echo "Unknown parameter! ${USER_OPT}"
               show_help
               exit 1
            fi

            USER_FUNC="${CSL_USER_GETOPT_PARAMS[${USER_OPT}]}"

            if ! is_declared_func ${USER_FUNC}; then
               echo "No function '${USER_FUNC}' for parameter '${USER_OPT}'!"
               exit 1
            fi

            #
            # if the next parameter does not start with a hyphen, its
            # most probably an argument to the $1 positional parameter.
            #
            if [ $# -ge 2 ] && [[ "${2}" =~ ^[^-] ]]; then
               USER_ARG="${2}"
               SHIFT=2
            fi

            $USER_FUNC $USER_ARG
            RETVAL=$?

            if [ "x${RETVAL}" != "x0" ]; then
               fail "Parameter function '${USER_FUNC}' exited non-zero: ${RETVAL}"
               exit 1
            fi

            shift $SHIFT
            unset -v USER_OPT USER_FUNC USER_ARG SHIFT
            continue
            ;;
      esac
   done

   #if [ -z "${ARGSPARSED}" ] || [ -z "${MODE}" ]; then
   #   echo "Invalid parameter(s)!"
   #   echo
   #   show_help
   #   exit 1
   #fi
   ! is_set CSL_DEBUG || debug "Debugging: enabled"
   ! is_set CSL_VERBOSE || verbose "Verbose output: enabled"
   ! is_set CSL_WARNING_LIMIT || debug "Warning limit: ${CSL_WARNING_LIMIT}"
   ! is_set CSL_CRITICAL_LIMIT || debug "Critical limit: ${CSL_CRITICAL_LIMIT}"

}

#
# is_range() returns true, if the argument given is in the form of an range.
# otherwise it returns false.
#
is_range ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty "${1}" || return 1

   if ! [[ "${1}" =~ ^(-?[[:digit:]]+[\.[:digit:]]*)?:(-?[[:digit:]]+[\.[:digit:]]*)?$ ]]; then
      return 1
   fi

   return 0
}

#
# is_integer() returns true, if the given argument is an integer number.
# it also accepts the form :[0-9] (value lower than) and [0-9]: (value
# greater than). otherwise it returns false.
#
is_integer ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty "${1}" || return 1
   [[ "${1}" =~ ^-?[[:digit:]]+$ ]] || return 1

   return 0
}

#
# is_float() returns true, if the given argument is a floating point number.
# otherwise it returns false.
#
is_float ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty "${1}" || return 1
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
   [ $# -eq 1 ] || return 1
   ! is_empty "${1}" || return 1

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

is_cmd ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty "${1}" || return 1

   command -v "${1}" >/dev/null 2>&1;
   return $?
}

is_func ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty "${1}" || return 1

   if [ "$(type -t ${1//[^a-zA-Z0-9_[:blank:][:punct:]]/})" != "function" ]; then
      return 1
   fi

   return 0
}

#
# validate_parameters() returns true, if the given command-line parameters are
# valid. otherwise it returns false.
#
validate_parameters ()
{
   if ! is_declared CSL_WARNING_LIMIT || is_empty "${CSL_WARNING_LIMIT}" || \
      ! is_declared CSL_CRITICAL_LIMIT || is_empty "${CSL_CRITICAL_LIMIT}"; then
      fail "warning and critical parameters are mandatory!"
      return 1
   fi

   if ! is_valid_limit "${CSL_WARNING_LIMIT}"; then
      fail "warning parameter contains an invalid value!"
      return 1
   fi

   if ! is_valid_limit "${CSL_CRITICAL_LIMIT}"; then
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
   # CSL_EXIT_TEXT minus 2 characters removes the ", " at the end.
   # CSL_EXIT_PERF minus 1 character remove the " " at the end.
   readonly STOP_TIME_PLUGIN="$(date +%s%3N)"

   if is_empty "${CSL_EXIT_TEXT}"; then
      echo "No hddtemp data available."
      ! is_exit_on_no_data_critical || exit ${CSL_EXIT_CRITICAL}
      exit ${CSL_EXIT_UNKNOWN}
   fi

   echo "${CSL_EXIT_TEXT:0:-2}|${CSL_EXIT_PERF:0:-1}"
   exit ${CSL_EXIT_CODE}
}

#
# show_help() displays the available parameter options to $0.
#
show_help ()
{
   local TEXT=

   if has_help_text; then
      TEXT="$(get_help_text)"
   else
      TEXT="${CSL_DEFAULT_HELP_TEXT}"
   fi

   echo
   echo -e "${TEXT}"
   echo
}

cleanup ()
{
   local EXITCODE=$?

   if [ ${#CSL_TEMP_DIRS} -lt 1 ]; then
      exit $EXITCODE
   fi

   local TMPDIR
   for TMPDIR in "${CSL_TEMP_DIRS[@]}"; do
      ! is_empty "${TMPDIR}" || continue
      is_dir "${TMPDIR}" || continue
      rm -rf ${TMPDIR}
   done

   exit $EXITCODE
}

startup ()
{
   readonly START_TIME_PLUGIN="$(date +%s%3N)"
}

rename_func ()
{
   local SRC_FUNC=$(declare -f ${1})
   local DST_FUNC="$2${DST_FUNC#${1}}"
   eval "${DST_FUNC}"
}

has_help_text ()
{
   is_declared CSL_HELP_TEXT || return 1
   ! is_empty "${CSL_HELP_TEXT}" || return 1

   return 0
}

set_help_text ()
{
   # the text might have been provided as first parameter.
   if [ $# -ge 1 ]; then
      ! is_empty "${1}" || return 1
      CSL_HELP_TEXT="${1}"
      return 0
   fi

   # otherwise we accept whatever is passed by STDIN
   read -r -d '' CSL_HELP_TEXT && true

   ! is_empty "${CSL_HELP_TEXT}" || return 1
   return 0
}

get_help_text ()
{
   has_help_text || return 1

   echo "${CSL_HELP_TEXT}"
   return 0
}

has_short_params ()
{
   is_declared CSL_GETOPT_SHORT || return 1
   ! is_empty "${CSL_GETOPT_SHORT}" || return 1

   return 0
}

has_long_params ()
{
   is_declared CSL_GETOPT_LONG || return 1
   ! is_empty "${CSL_GETOPT_LONG}" || return 1

   return 0
}


add_param ()
{
   [ $# -eq 3 ] || { fail "exactly 3 parameters are required!"; return 1; }

   local GETOPT_SHORT="${1}"
   local GETOPT_LONG="${2}"
   local OPT_FUNC="${3}"

   if is_empty "${GETOPT_SHORT}" && is_empty "${GETOPT_LONG}"; then
      fail "at least a short or a long option name has to be provided."
      return 1
   fi

   if ! is_empty "${GETOPT_SHORT}"; then
      if  ! [[ "${GETOPT_SHORT}" =~ ^-?([[:alnum:]]):?$ ]]; then
         fail "given short parameter is invalid."
         return 1
      fi
      GETOPT_SHORT="${BASH_REMATCH[1]}"
   fi

   if ! is_empty "${GETOPT_LONG}"; then
      if ! [[ "${GETOPT_LONG}" =~ ^-?-?([[:alnum:]]+):?$ ]]; then
         fail "given long parameter is invalid."
         return 1
      fi
      GETOPT_LONG="${BASH_REMATCH[1]}"
   fi

   if ! is_declared_func $OPT_FUNC; then
      fail "function ${OPT_FUNC} is not declared."
      return 1
   fi

   if ! is_empty "${GETOPT_SHORT}"; then
      CSL_USER_GETOPT_PARAMS["${GETOPT_SHORT}"]="${OPT_FUNC}"
      CSL_GETOPT_SHORT+="${GETOPT_SHORT}"
   fi

   if ! is_empty "${GETOPT_LONG}"; then
      CSL_USER_GETOPT_PARAMS["${GETOPT_LONG}"]="${OPT_FUNC}"
      CSL_GETOPT_LONG+="${GETOPT_SHORT},"
   fi

   return 0
}

add_prereq ()
{
   [ $# -ge 1 ] || return 1
   local PREREQ

   for PREREQ in "${@}"; do
      CSL_USER_PREREQ+=( "${PREREQ//[^a-zA-Z0-9_[:blank:][:punct:]]/}" )
   done

   return 0
}

get_short_params ()
{
   has_short_params || return 1

   echo "${CSL_GETOPT_SHORT}"
   return 0
}

get_long_params ()
{
   has_long_params || return 1

   # remove the trailing comma from the end of the string.
   echo "${CSL_GETOPT_LONG:0:-1}"
   return 0
}

create_tmpdir ()
{
   local TMPDIR= RETVAL=

   if [ ${#CSL_TEMP_DIRS[@]} -gt 10 ]; then
      fail "I am not willing to create more than 10 temp-directories for you!"
      exit 1
   fi

   TMPDIR="$(mktemp -d -p /tmp csl.XXXXXX)"
   RETVAL=$?

   if [ "x${RETVAL}" != "x0" ]; then
      fail "mktemp exited non-zero!";
      exit 1
   fi

   if is_empty "${TMPDIR}"; then
      fail "mktemp did not return the path of the created temp-directory in /tmp."
      exit 1
   fi

   if ! is_dir "${TMPDIR}"; then
      fail "mktemp did not create a temp-directory for the returned path ${TMPDIR}."
      exit 1
   fi

   CSL_TEMP_DIRS=( "${TMPDIR}" )

   setup_cleanup_trap ||  \
      { fail "Failed to install cleanup trap!"; exit 1; }

   echo "${TMPDIR}"
}

setup_cleanup_trap ()
{
   #
   # has the cleanup trap already been installed
   #
   if trap -p | grep -qsE "^trap[[:blank:]]--[[:blank:]]'cleanup'[[:blank:]]"; then
      return 0
   fi

   trap cleanup INT QUIT TERM EXIT
   return $?
}

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
# Anyway we exit with $CSL_EXIT_UNKNOWN in case.
#
#exit $CSL_EXIT_UNKNOWN

#
# </TheActualWorkStartsHere>
#
