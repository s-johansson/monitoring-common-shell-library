#!/bin/bash

###############################################################################


# This file is part of monitoring-common-shell-library v1.2.
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
# remember, on the shell TRUE=0, FALSE=1.
#

readonly CSL_EXIT_OK=0
readonly CSL_EXIT_WARNING=1
readonly CSL_EXIT_CRITICAL=2
readonly CSL_EXIT_UNKNOWN=3

readonly CSL_TRUE=true
readonly CSL_FALSE=false

# reset variables, just in case...
declare -g CSL_EXIT_NO_DATA_IS_CRITICAL=0
declare -g CSL_RESULT_CODE= CSL_RESULT_TEXT= CSL_RESULT_PERFDATA=
declare -g CSL_WARNING_LIMIT= CSL_CRITICAL_LIMIT=
declare -g CSL_DEBUG= CSL_VERBOSE=
declare -g CSL_DEFAULT_HELP_TEXT= CSL_HELP_TEXT=
declare -g CSL_GETOPT_SHORT= CSL_GETOPT_LONG=

readonly CSL_DEFAULT_GETOPT_SHORT='w:c:dhv'
readonly CSL_DEFAULT_GETOPT_LONG='warning:,critical:,debug,verbose,help'

readonly -a CSL_DEFAULT_PREREQ=( 'getopt' 'cat' 'bc' 'mktemp' )
declare -a CSL_USER_PREREQ=()
declare -A CSL_USER_PARAMS=()
declare -A CSL_USER_GETOPT_PARAMS=()

#
# on any invocation of create_tmpdir(), that one will push the name
# of the returned temp-directory to CSL_TEMP_DIRS[]. cleanup()
# could then take care of it and removes all the temp-directories
# on script-exit.
#
declare -a CSL_TEMP_DIRS=()

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


# @function is_debug()
# @brief returns 0 if debugging is enabled, otherwise it returns 1.
# @return int 0 or 1
# @end
is_debug ()
{
   is_declared CSL_DEBUG || return 1;
   ! is_empty "${CSL_DEBUG}" || return 1;
   [ "x${CSL_DEBUG}" != "x0" ] || return 1;

   return 0
}
readonly -f is_debug

# @function debug()
# @brief prints output only if --debug or -d parameters \ have been given. \
# debug output is sent to STDERR! \
# @param1 string $debug_text
# @return int
#
debug ()
{
   is_debug || return 0;

   echo -e "${FUNCNAME[1]}([${BASH_LINENO[0]}]):\t${1}" >&2
}
readonly -f debug

# @function fail()
# @brief prints the fail-text as well as the function and code-line from \
# which it was called.
# @param1 string $fail_text
# @return int
#
fail ()
{
   echo -e "${FUNCNAME[1]}([${BASH_LINENO[0]}]):\t${1}"
}
readonly -f fail

# @function: is_verbose()
# @brief returns 0 if verbose-logging is enabled, otherwise it returns 1.
# @return int 0 on success, 1 on failure
is_verbose ()
{
   is_declared CSL_VERBOSE || return 1;
   ! is_empty "${CSL_VERBOSE}" || return 1;
   [ "x${CSL_VERBOSE}" != "x0" ] || return 1;

   return 0
}
readonly -f is_verbose

# @function verbose()
# @brief prints output only if --verbose or -v parameters have been given. \
# verbose output is sent to STDERR!
# @param1 string $log_text
# @return int
verbose ()
{
   is_verbose || return 0;

   echo -e "${FUNCNAME[1]}([${BASH_LINENO[0]}]):\t${1}" >&2
}
readonly -f verbose

# @function csl_is_exit_on_no_data_critical()
# @brief returns 0, if it has been choosen, that no-data-is-available is \
# a critical error. otherwise it returns 1.
# @return int 0 on success, 1 on failure
csl_is_exit_on_no_data_critical ()
{
   is_declared CSL_EXIT_NO_DATA_IS_CRITICAL || return 1
   ! is_empty "${CSL_EXIT_NO_DATA_IS_CRITICAL}" || return 1
   [ "x${CSL_EXIT_NO_DATA_IS_CRITICAL}" != "x0" ] || return 1
   return 0
}
readonly -f csl_is_exit_on_no_data_critical

# @function: csl_check_requirements()
# @brief: tests for other required tools. It also invokes an possible \
# plugin-specific requirement-check function called plugin_prereq().
# @return int 0 on success, 1 on failure
csl_check_requirements ()
{
   local RETVAL=0

   # is Bash actually used?
   ( is_declared BASH_VERSINFO && ! is_empty "${BASH_VERSINFO[0]}" ) || \
      { fail "Strangely BASH_VERSINFO variable is not (correctly) set!"; exit ${CSL_EXIT_CRITICAL}; }

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

   if is_func plugin_prereq; then
      plugin_prereq;
      RETVAL=$?
   fi

   return $RETVAL
}
readonly -f csl_check_requirements

# @function csl_get_limit_range()
# @brief returns the provided threshold as range in the form of \
# 'MIN MAX'. In case the provided value is a single value (either \
# integer or float), then 'x MAX' is returned.
# @param1 string $limit
# @output string
# @return int 0 on success, 1 on failure
csl_get_limit_range ()
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
readonly -f csl_get_limit_range

# @function is_declared()
# @brief returns 0 if the provided variable has been declared (that \
# does not mean, that the variable actually has a value!), otherwise \
# it returns 1.
# @param1 string $var
# @return int 0 on success, 1 on failure
is_declared ()
{
   [ $# -eq 1 ] || return 1
   declare -p "${1}" &> /dev/null
   return $?
}
readonly -f is_declared

# @function: is_declared_func()
# @brief returns 0 if the provided function name refers to an \
# already declared function. Otherwise it returns 1.
# @param1 string $var
# @return int 0 on success, 1 on failure
is_declared_func ()
{
   [ $# -eq 1 ] || return 1
   declare -p -f "${1}" &> /dev/null
   return $?
}
readonly -f is_declared_func

# @function is_set()
# @brief returns 0, if all the provided values are set (non-empty string). \
# specific to this library, the value 'x' also signals emptiness.
# @param1 string $val1
# @param2 string $val2
# @param3 string ...
# @return int 0 on success, 1 on failure
is_set ()
{
   [ $# -ge 1 ] || return 1

   local PARAM
   for PARAM in "${@}"; do
      ! is_empty "${PARAM}" || return 1;
      [ "${PARAM}" != "x" ] || return 1;
   done

   return 0
}
readonly -f is_set

# @function is_empty()
# @brief returns 0, if the provided string has a zero length. \
# Otherwise it returns 1.
# @param1 string $string
# @return int 0 on success, 1 on failure
is_empty ()
{
   [ $# -eq 1 ] || return 1
   [ -z "${1}" ] || return 1

   return 0
}
readonly -f is_empty

# @function is_match()
# @brief invokes the Basic Calculator (bc) and provideѕ it the \
# given $condition. If the condition is met in bc, that one returns '1' - \
# in this is_match() returns 0. Otherwise bc will return '0', than \
# is_match() returns 1.... \
# @param1 string $condition
# @return int 0 on success, 1 on failure
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
readonly -f is_match

# @function is_dir()
# @brief returns 0, if the given directory actually exists. \
# Otherwise it returns 1.
# @param1 string $path
# @return int 0 on success, 1 on failure
is_dir ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty "${1}" || return 1
   [ -d "${1}" ] || return 1

   return 0
}
readonly -f is_dir

# @function: eval_limits()
# @brief evaluates the given value against the given \
# WARNING ($2) and CRITICAL ($3) thresholds.
# @param1 string $value
# @param2 string $warning
# @param3 string $critical
# @output OK|WARNING|CRITICAL|UNKNOWN
# @return int 0|1|2|3
eval_limits ()
{
   [ $# -eq 3 ] || \
      { fail "eval_limits() requires 3 parameters."; return 1; }

   ( ! is_empty "${1}" && ! is_empty "${2}" && ! is_empty "${3}" ) || return 1

   local VALUE="${1}"
   local WARNING="${2}" WARN_MIN= WARN_MAX=
   local CRITICAL="${3}" CRIT_MIN= CRIT_MAX=
   local TEXT= STATE= MATCH=

   read -r WARN_MIN WARN_MAX < <(csl_get_limit_range "${WARNING}")
   read -r CRIT_MIN CRIT_MAX < <(csl_get_limit_range "${CRITICAL}")

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
readonly -f eval_limits

# @function csl_parse_parameters()
# @brief uses GNU getopt to parse the given command-line parameters.
# @param1 string $params
# @return int 0 on success, 1 on failure
csl_parse_parameters ()
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

   if csl_has_short_params; then
      TEMP=$(csl_get_short_params)

      if ! is_empty "${TEMP}"; then
         GETOPT_SHORT+="${TEMP}"
      fi
   fi

   if csl_has_long_params; then
      TEMP=$(csl_get_long_params)

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

            local USER_OPT="${1}" OPT_VAR= OPT_ARG= SHIFT=1

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

            OPT_VAR="${CSL_USER_GETOPT_PARAMS[${USER_OPT}]}"

            #
            # if the next parameter does not start with a hyphen, its
            # most probably an argument to the $1 positional parameter.
            #
            if [ $# -ge 2 ] && [[ "${2}" =~ ^[^-] ]]; then
               OPT_ARG="${2}"
               SHIFT=2
            fi

            #
            # if the option is only meant to be a variable.
            #
            if ! is_declared_func ${OPT_VAR}; then
               is_empty "${OPT_ARG}" && CSL_USER_PARAMS[${OPT_VAR}]=${CSL_TRUE}
               ! is_empty "${OPT_ARG}" && CSL_USER_PARAMS[${OPT_VAR}]="${OPT_ARG}"
               shift $SHIFT
               unset -v USER_OPT OPT_VAR OPT_ARG SHIFT
               continue
            fi

            #
            # or if it is handled by a function.
            #
            if ! is_func "${OPT_VAR}"; then
               echo "No valid function '${OPT_VAR}' for parameter '${USER_OPT}'!"
               exit 1
            fi

            $OPT_VAR $OPT_ARG
            RETVAL=$?

            if [ "x${RETVAL}" != "x0" ]; then
               fail "Parameter function '${OPT_VAR}' exited non-zero: ${RETVAL}"
               exit 1
            fi

            shift $SHIFT
            unset -v USER_OPT OPT_VAR OPT_ARG SHIFT
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
readonly -f csl_parse_parameters

# @function is_range()
# @brief returns 0, if the argument given is in the form of an range. \
# Otherwise it returns 1.
# @param1 string $range
# @return int 0 on success, 1 on failure
is_range ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty "${1}" || return 1

   if ! [[ "${1}" =~ ^(-?[[:digit:]]+[\.[:digit:]]*)?:(-?[[:digit:]]+[\.[:digit:]]*)?$ ]]; then
      return 1
   fi

   return 0
}
readonly -f is_range

# @function is_integer()
# @brief returns 0, if the given argument is an integer number. \
# it also accepts the form :[0-9] (value lower than) and [0-9]: (value \
# greater than). Otherwise it returns 1.
# @param1 string $integer
# @return int 0 on success, 1 on failure
is_integer ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty "${1}" || return 1
   [[ "${1}" =~ ^-?[[:digit:]]+$ ]] || return 1

   return 0
}
readonly -f is_integer

# @function is_float()
# @brief returns 0, if the given argument is a floating point number. \
# Otherwise it returns 1.
# @param1 string $float
# @return int 0 on success, 1 on failure
is_float ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty "${1}" || return 1
   [[ "${1}" =~ ^-?[[:digit:]]+\.[[:digit:]]*$ ]] || return 1

   return 0
}
readonly -f is_float

# @function: is_valid_limit()
# @brief performs the checks on the given warning \
# and critical values and returns 0, if they are. \
# Otherwise it returns 1.
# @param1 string $limit
# @return int 0 on success, 1 on failure
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
readonly -f is_valid_limit

# @function: is_cmd()
# @brief returns 0, if the provided external command exists. \
# Otherwise it returns 1.
# @param1 string $command
# @return int 0 on success, 1 on failure
is_cmd ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty "${1}" || return 1

   command -v "${1}" >/dev/null 2>&1;
   return $?
}
readonly -f is_cmd

# @function is_func()
# @brief returns 0, if the given function name refers an already \
# declared function. Otherwise it returns 1
# @param1 string $funcname
# @return int 0 on success, 1 on failure
is_func ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty "${1}" || return 1

   if [ "$(type -t ${1//[^a-zA-Z0-9_[:blank:][:punct:]]/})" != "function" ]; then
      return 1
   fi

   return 0
}
readonly -f is_func

# @function csl_validate_parameters()
# @brief returns 0, if the given command-line parameters are \
# valid. Otherwise it returns 1.
# @return int 0 on success, 1 on failure
csl_validate_parameters ()
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

   local RETVAL=0

   if is_func plugin_params_validate; then
      plugin_params_validate;
      RETVAL=$?
   fi

   return $RETVAL
}

# @function set_result_text()
# @brief accepts the plugin-result either as first parameter, \
# or reads it from STDIN (what allows heredoc usage for example). \
# In case of STDIN, the read-timeout is set to 1 seconds.
# @param1 string $text
# @return int 0 on success, 1 on failure
set_result_text ()
{
   # the text might have been provided as first parameter.
   if [ $# -ge 1 ]; then
      ! is_empty "${1}" || return 1
      CSL_RESULT_TEXT="${1}"
      return 0
   fi

   # otherwise we accept whatever is passed by STDIN
   read -r -d '' -t 1 CSL_RESULT_TEXT && true

   ! is_empty "${CSL_RESULT_TEXT}" || return 1
   return 0
}
readonly -f set_result_text

# @function has_result_text()
# @brief returns 0, if the plugin-result has already \
# been set. Otherwise it returns 1.
# @return int 0 on success, 1 on failure
has_result_text ()
{
   is_declared CSL_RESULT_TEXT || return 1
   ! is_empty "${CSL_RESULT_TEXT}" || return 1

   return 0
}
readonly -f has_result_text

# @function get_result_text()
# @brief outputs the plugin-result, if it has already been set - \
# in this case it returns 0. Otherwise it returns 1.
# @output string
# @return int 0 on success, 1 on failure
get_result_text ()
{
   has_result_text || return 1

   echo "${CSL_RESULT_TEXT}"
   return 0
}
readonly -f get_result_text

# @function set_result_perfdata()
# @brief accepts the plugin-perfdata as first parameter. \
# On success it returns 0, otherwise 1.
# @param1 string $perfdata
# @return int 0 on success, 1 on failure
set_result_perfdata ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty "${1}" || return 1

   CSL_RESULT_PERFDATA="${1}"
   return 0
}
readonly -f set_result_perfdata

# @function has_result_perfdata()
# @brief returns 0, if the plugin-perfdata has already \
# been set. Otherwise it returns 1.
# @return int 0 on success, 1 on failure
has_result_perfdata ()
{
   is_declared CSL_RESULT_PERFDATA || return 1
   ! is_empty "${CSL_RESULT_PERFDATA}" || return 1

   return 0
}
readonly -f has_result_perfdata

# @function get_result_perfdata()
# @brief outputs the plugin-perfdata, if it has already \
# been set - in this case it returns 0. Otherwise it returns 1.
# @output string
# @return int 0 on success, 1 on failure
get_result_perfdata ()
{
   has_result_perfdata || return 1

   echo "${CSL_RESULT_PERFDATA}"
   return 0
}
readonly -f get_result_perfdata

# @function set_result_code()
# @brief accepts the plugin-exit-code as first parameter. \
# On success it returns 0, otherwise 1.
# @param1 string $perfdata
# @return int 0 on success, 1 on failure
set_result_code ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty "${1}" || return 1
   [[ "${1}" =~ ^[[:digit:]]{1,3}$ ]] || return 1

   CSL_RESULT_CODE="${1}"
   return 0
}
readonly -f set_result_code

# @function has_result_code()
# @brief returns 0, if the plugin-code has already \
# been set. Otherwise it returns 1.
# @return int 0 on success, 1 on failure
has_result_code ()
{
   is_declared CSL_RESULT_CODE || return 1
   ! is_empty "${CSL_RESULT_CODE}" || return 1
   [[ "${CSL_RESULT_CODE}" =~ ^[[:digit:]]{1,3}$ ]] || return 1

   return 0
}
readonly -f has_result_code

# @function get_result_code()
# @brief outputs the plugin-code, if it has already \
# been set - in this case it returns 0. Otherwise it returns 1.
# @output string
# @return int 0 on success, 1 on failure
get_result_code ()
{
   has_result_code || return 1

   echo "${CSL_RESULT_CODE}"
   return 0
}
readonly -f get_result_code

# @function print_result()
# @brief outputs the final result as required for (c) Nagios, \
# (c) Icinga, etc.
# @output plugin-result + plugin-perfdata
# @return int plugin-code
print_result ()
{
   readonly STOP_TIME_PLUGIN="$(date +%s%3N)"

   if ! is_empty "${START_TIME_PLUGIN}" && ! is_empty "${STOP_TIME_PLUGIN}"; then
      ((DIFF_TIME_PLUGIN = STOP_TIME_PLUGIN - START_TIME_PLUGIN))
      local CYCLE_TIME=" plugin_time=${DIFF_TIME_PLUGIN}ms"
   fi

   if ! has_result_text || ! has_result_code; then
      echo "Plugin state is UNKNOWN!"
      ! csl_is_exit_on_no_data_critical || exit ${CSL_EXIT_CRITICAL}
      exit ${CSL_EXIT_UNKNOWN}
   fi

   local RESULT="$(get_result_text)"

   if ! has_result_perfdata; then
      echo "${RESULT}"
      exit $(get_result_code)
   fi

   local PERFDATA="$(get_result_perfdata)${CYCLE_TIME-}"
   echo "${RESULT}|${PERFDATA}"
   exit $(get_result_code)
}
readonly -f print_result

# @function show_help()
# @brief displays the help text. \
# \
# If a plugin-specifc help-text has been set via set_help_text(), \
# that one is printed. Otherwise the libraries $CSL_DEFAULT_HELP_TEXT \
# is used.
# @output plugin-helptext
# @return int 0 on success, 1 on failure
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
readonly -f show_help

# @function cleanup()
# @brief is a function, that would be called on soon as this \
# script has finished. \
# It must be set upped by using setup_cleanup_trap ().
# @param1 int $exit_code
# @return int 0 on success, 1 on failure
cleanup ()
{
   local EXITCODE=$?

   if is_func plugin_cleanup; then
      plugin_cleanup;
   fi

   if ! is_declared CSL_TEMP_DIRS || [ ${#CSL_TEMP_DIRS[@]} -lt 1 ]; then
      exit $EXITCODE
   fi

   local CSL_TMPDIR
   for CSL_TMPDIR in "${CSL_TEMP_DIRS[@]}"; do
      ! is_empty "${CSL_TMPDIR}" || continue
      is_dir "${CSL_TMPDIR}" || continue
      rm -rf ${CSL_TMPDIR}
   done

   if is_func plugin_params; then
      plugin_params;
   fi

   exit $EXITCODE
}
readonly -f cleanup

# @function startup()
# @brief is the first library function, that any plugin should invoke.
# @param1 string $cmdline_params
# @output plugin-result + plugin-perfdata
# @return int 0 on success, 1 on failure
startup ()
{
   readonly START_TIME_PLUGIN="$(date +%s%3N)"

   csl_check_requirements || \
      { echo "csl_check_requirements() returned non-zero!"; exit 1; }
   csl_parse_parameters "${@}" || \
      { echo "csl_parse_parameters() returned non-zero!"; exit 1; }
   csl_validate_parameters || \
      { echo "csl_validate_parameters() returned non-zero!"; exit 1; }

   if is_func plugin_startup; then
      plugin_startup;
   fi

   if ! is_declared_func plugin_worker || ! is_func plugin_worker; then
      fail "There is no plugin_worker() function defined by your plugin!"
      return 1
   fi

   plugin_worker "${@}"

   print_result ||  \
      { echo "print_result() returned non-zero!"; exit 1; }

   return 0
}
readonly -f startup

# @function set_help_text()
# @brief: accepts a plugin-specific help-text, that is \
# returned when show_help() is called. \
# \
# The text can either be provided as first parameter or being read \
# from STDIN (what allows heredoc usage for example).
# @param1 string $text
# @return int 0 on success, 1 on failure
set_help_text ()
{
   # the text might have been provided as first parameter.
   if [ $# -ge 1 ]; then
      ! is_empty "${1}" || return 1
      CSL_HELP_TEXT="${1}"
      return 0
   fi

   # otherwise we accept whatever is passed by STDIN
   read -r -d '' -t 1 CSL_HELP_TEXT && true

   ! is_empty "${CSL_HELP_TEXT}" || return 1
   return 0
}
readonly -f set_help_text

# @function has_help_text()
# @brief returns 0, if a plugin-specific help-text has been set. \
# Otherwise it returns 1.
# @return int 0 on success, 1 on failure
has_help_text ()
{
   is_declared CSL_HELP_TEXT || return 1
   ! is_empty "${CSL_HELP_TEXT}" || return 1

   return 0
}
readonly -f has_help_text

# @function get_help_text()
# @brief outputs a plugin-specific help-text, if it has been previously \
# set by set_help_text(). In this case it returns 0, otherwise 1.
# @output plugin-helptext
# @return int 0 on success, 1 on failure
get_help_text ()
{
   has_help_text || return 1

   echo "${CSL_HELP_TEXT}"
   return 0
}
readonly -f get_help_text

# @function add_param()
# @brief registers an additional, plugin-specific command-line-parameter.
# @param1 string $short_param set '' for no short-parameter
# @param2 string $long_param set '' for no long-parameter
# @param3 string $opt_var variable- or function-name to store/handle cmdline arguments.
# @param4 string $opt_default default value, optional
# @return int 0 on success, 1 on failure
add_param ()
{
   ( [ $# -ge 3 ] && [ $# -le 4 ] ) || { fail "3 or 4 parameters are required!"; return 1; }

   local GETOPT_SHORT="${1}"
   local GETOPT_LONG="${2}"
   local OPT_VAR="${3}"
   [ $# -eq 4 ] && local OPT_DEFAULT="${4}"

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
      if ! [[ "${GETOPT_LONG}" =~ ^-?-?([[:alnum:]]+)(:?)$ ]]; then
         fail "given long parameter is invalid."
         return 1
      fi
      GETOPT_LONG="${BASH_REMATCH[1]}"
   fi

   if [[ -v CSL_USER_PARAMS[${OPT_VAR}] ]]; then
      fail "Variable ${OPT_VAR} is already declared."
      return 1
   fi

   if ! is_empty "${GETOPT_SHORT}"; then
      CSL_USER_GETOPT_PARAMS["${GETOPT_SHORT}"]="${OPT_VAR}"
      CSL_GETOPT_SHORT+="${GETOPT_SHORT}${BASH_REMATCH[2]-}"
   fi

   if ! is_empty "${GETOPT_LONG}"; then
      CSL_USER_GETOPT_PARAMS["${GETOPT_LONG}"]="${OPT_VAR}"
      CSL_GETOPT_LONG+="${GETOPT_SHORT}${BASH_REMATCH[2]-},"
   fi

   if is_declared OPT_DEFAULT; then
      CSL_USER_PARAMS[${OPT_VAR}]="${OPT_DEFAULT}"
   fi

   #echo "Added parameter ${OPT_VAR}: short:${GETOPT_SHORT-}, long:${GETOPT_LONG-}"
   return 0
}
readonly -f add_param

# @function has_param()
# @brief returns 0, if the given parameter name actually is defined. \
# Otherwise it returns 1.
# @param1 string $param
# @return int 0 on success, 1 on failure
has_param ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty "${1}" || return 1

   if ! [[ -v CSL_USER_PARAMS[${1}] ]]; then
      return 1
   fi

   return 0
}
readonly -f has_param

# @function has_param_value()
# @brief returns 0, if the given parameter has been defined \
# and consists of a value that is not empty. Otherwise it returns 1.
# @param1 string $param
# @return int 0 on success, 1 on failure
#
has_param_value ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty "${1}" || return 1
   has_param "${1}" || return 1
   ! is_empty "${CSL_USER_PARAMS[${1}]}" || return 1

   return 0
}
readonly -f has_param_value

# @function get_param_value()
# @brief outputs the value of a given parameter, if it has \
# been set already - in this case it returns 0. Otherwise it returns 1.
# @param1 string $param
# @return int 0 on success, 1 on failure
get_param_value ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty "${1}" || return 1
   has_param_value "${1}" || return 1

   echo "${CSL_USER_PARAMS[${1}]}"
   return 0
}
readonly -f get_param_value

# @function get_param()
# @brief works similar as get_param_value(), but it also \
# accepts the short- (eg. -w) and long-parameters (eg. --warning) \
# as indirect lookup keys. On success, the value is printed and \
# the function returns 0. Otherwise it returns 1.
# @param1 string $param
# @output param-value
# @return int 0 on success, 1 on failure
get_param ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty "${1}" || return 1

   if ! [[ "${1}" =~ ^[[[:alnum:]]_]+$ ]]; then
      if ! [[ -v CSL_USER_PARAMS[${1}] ]]; then
         return 1
      fi

      echo "${CSL_USER_PARAMS[${1}]}"
      return 0
   fi

   if ! [[ "${1}" =~ ^-?-?[[:alnum:]]+$ ]]; then
      return 1
   fi

   if ! [[ -v CSL_USER_GETOPT_PARAMS[${1}] ]]; then
      return 1
   fi

   local KEY="${CSL_USER_GETOPT_PARAMS[${1}]}"

   echo "${CSL_USER_PARAMS[${KEY}]}"
   return 0
}
readonly -f get_param

# @function add_prereq()
# @brief registers a new plugin-requesit. Those are \
# then handled in csl_check_requirements(). On success \
# the function returns 0, otherwise it returns 1. \
# \
# Multiple requesits can be registered in one step. \
#
# @param1 string $prereq1 $prereq2 etc.
# @return int 0 on success, 1 on failure
add_prereq ()
{
   [ $# -ge 1 ] || return 1
   local PREREQ

   for PREREQ in "${@}"; do
      CSL_USER_PREREQ+=( "${PREREQ//[^a-zA-Z0-9_[:blank:][:punct:]]/}" )
   done

   return 0
}
readonly -f add_prereq

# @function csl_has_short_params()
# @brief returns 0, if parameters in short form (-d -w 5...) \
# have been given on the command line. Otherwise it returns 1.
# @return int 0 on success, 1 on failure
csl_has_short_params ()
{
   is_declared CSL_GETOPT_SHORT || return 1
   ! is_empty "${CSL_GETOPT_SHORT}" || return 1

   return 0
}
readonly -f csl_has_short_params

# @function csl_has_long_params()
# @brief returns 0, if parameters in long form (--debug --warning 5...) \
#  have been given on the command line. Otherwise it returns 1.
# @return int 0 on success, 1 on failure
csl_has_long_params ()
{
   is_declared CSL_GETOPT_LONG || return 1
   ! is_empty "${CSL_GETOPT_LONG}" || return 1

   return 0
}
readonly -f csl_has_long_params

# @function csl_get_short_params()
# @brief outputs the registered short command-line-parameters \
# in the form as required by GNU getopt.
# @output short-params
# @return int 0 on success, 1 on failure
csl_get_short_params ()
{
   csl_has_short_params || return 1

   echo "${CSL_GETOPT_SHORT}"
   return 0
}
readonly -f csl_get_short_params

# @function csl_get_long_params()
# @brief outputs the registered long command-line-parameters \
# in the form as required by GNU getopt.
# @output long-params
# @return int 0 on success, 1 on failure
csl_get_long_params ()
{
   csl_has_long_params || return 1

   # remove the trailing comma from the end of the string.
   echo "${CSL_GETOPT_LONG:0:-1}"
   return 0
}
readonly -f csl_get_long_params

# @function create_tmpdir()
# @brief creates and tests for a temporary directory \
# being created by mktemp. \
# Furthermore it registers the temp-directory in the variable \
# CSL_TEMP_DIRS[] that is eval'ed in case by cleanup(), to \
# remove plugin residues. \
# there is a hard-coded limit for max. 10 temp-directories.
# @output temp-directory
# @return int 0 on success, 1 on failure
create_tmpdir ()
{
   local CSL_TMPDIR= RETVAL=

   if [ ${#CSL_TEMP_DIRS[@]} -gt 10 ]; then
      fail "I am not willing to create more than 10 temp-directories for you!"
      exit 1
   fi

   CSL_TMPDIR="$(mktemp -d -p /tmp csl.XXXXXX)"
   RETVAL=$?

   if [ "x${RETVAL}" != "x0" ]; then
      fail "mktemp exited non-zero!";
      exit 1
   fi

   if is_empty "${CSL_TMPDIR}"; then
      fail "mktemp did not return the path of the created temp-directory in /tmp."
      exit 1
   fi

   if ! is_dir "${CSL_TMPDIR}"; then
      fail "mktemp did not create a temp-directory for the returned path ${CSL_TMPDIR}."
      exit 1
   fi

   CSL_TEMP_DIRS=( "${CSL_TMPDIR}" )
   echo "${CSL_TMPDIR}"
}
readonly -f create_tmpdir

# @function setup_cleanup_trap()
# registers a signal-trap for certain signals like \
# EXIT and INT, to call the cleanup() function on program-termination \
# (irrespectivly of success or failure). \
# \
# Note that the cleanup trap must be installed from the plugin. \
# As mostly these libraries functions will be called within a subshell \
# (eg. $(create_tmpdir)), the trap would only life within the context \
# of this subshell and would immediately be fired as soon as create_tmpdir() \
# finish. \
# @return int 0 on success, 1 on failure
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
readonly -f setup_cleanup_trap

#
# </Functions>
#


###############################################################################
