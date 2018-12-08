#!/bin/bash

###############################################################################


# This file is part of monitoring-common-shell-library v1.8
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

# @author Andreas Unterkircher
# @license AGPLv3
# @title monitoring-common-shell-library Function Reference
# @version 1.8

set -u -e -o pipefail  # exit-on-error, error on undeclared variables.


###############################################################################


#
# <Variables>
#

# @var CSL_VERSION
# @description the library major and minor version number
readonly CSL_VERSION="1.8"

# @var CSL_TRUE
readonly CSL_TRUE=true
# @var CSL_FALSE
readonly CSL_FALSE=false

# @var CSL_EXIT_OK
readonly CSL_EXIT_OK=0
# @var CSL_EXIT_WARNING
readonly CSL_EXIT_WARNING=1
# @var CSL_EXIT_CRITICAL
readonly CSL_EXIT_CRITICAL=2
# @var CSL_EXIT_UNKNOWN
readonly CSL_EXIT_UNKNOWN=3

#
# declare & reset variables, just in case they are already set...
#

# @var CSL_EXIT_NO_DATA_IS_CRITICAL
# @description if set to true, no result-data being set until
# the end of the script (actually until print_result() is
# invoked), will be treated as CRITICAL instead of exiting
# with state UNKNOWN.
# @example CSL_EXIT_NO_DATA_IS_CRITICAL=true -> exits CRITICAL
# CSL_EXIT_NO_DATA_IS_CRITICAL=false -> exits UNKNOWN
declare -g CSL_EXIT_NO_DATA_IS_CRITICAL="${CSL_FALSE}"

# @var CSL_DEBUG
# @description if set to true, debugging output will be enabled.
# @example CSL_DEBUG=false -> debugging disabled
# CSL_DEBUG=true -> debugging enabled
declare -g CSL_DEBUG="${CSL_FALSE}"

# @var CSL_VERBOSE
# @description if set to true, verbose console output will be enabled.
# @example CSL_VERBOSE=false -> verbose output disabled
# CSL_VERBOSE=true -> verbose output enabled
declare -g CSL_VERBOSE="${CSL_FALSE}"

# @var CSL_RESULT_CODE
# @description this variable will held the final plugin-exit code.
declare -g CSL_RESULT_CODE=''

# @var CSL_RESULT_TEXT
# @description this variable will held the final plugin-text output.
declare -g CSL_RESULT_TEXT=''

# @var CSL_RESULT_PERFDATA
# @description this variable will held the final plugin-performance data.
declare -g CSL_RESULT_PERFDATA=''

# @var CSL_RESULT_VALUES
# @description this associatative array will be filled by the plugin with
# the read measurement values, and later be read to evaluate the
# plugins result.
declare -A CSL_RESULT_VALUES=()

# @var CSL_GETOPT_SHORT
# @description this variable gets filled with plugin-specific getopt short
# parameters.
declare -g CSL_GETOPT_SHORT=''

# @var CSL_GETOPT_LONG
# @description this variable gets filled with plugin-specific getopt long
# parameters.
declare -g CSL_GETOPT_LONG=''

# @var CSL_DEFAULT_GETOPT_SHORT
# @description this variable contains the minimum set of getopt short
# parameters to be used as command-line parameters.
readonly CSL_DEFAULT_GETOPT_SHORT='c:dhvw:'

# @var CSL_DEFAULT_GETOPT_LONG
# @description this variable contains the minimum set of getopt long
# parameters to be used as command-line parameters.
readonly CSL_DEFAULT_GETOPT_LONG='critical:,debug,help,verbose,warning:'

# @var CSL_DEFAULT_PREREQ
# @description this variable helds the minimum set of external program
# dependencies, this library requires. additional plugin-specific
# can be added by `add_prereq`.
# * bc, for threshold evaluation.
# * getopt, for (advanced) command-line parameter parsing.
# * mktemp, to create temporary directories.
readonly -a CSL_DEFAULT_PREREQ=(
   'bc'
   'getopt'
   'mktemp'
)

# @var CSL_WARNING_THRESHOLD
# @description this associatative array helds the plugin-specific warning
# thresholds and gets filled by the command-line parameter --warning (-w).
declare -g -A CSL_WARNING_THRESHOLD=()

# @var CSL_CRITICAL_THRESHOLD
# @description this associatative array helds the plugin-specific critical
# thresholds and gets filled by the command-line parameter --critical (-c).
declare -g -A CSL_CRITICAL_THRESHOLD=()

# @var CSL_USER_PREREQ
# @description this index array helds the plugin-specific external dependencies.
# This variable is best to be filled with `add_reqreq`. In the end, these
# requirements will be merged with those specified in CSL_DEFAULT_PREREQ.
declare -g -a CSL_USER_PREREQ=()

# @var CSL_USER_PARAMS
# @description this index array helds the plugin-specific getopt parameters.
# This variable is best to be filled with `add_params` to register
# an additional parameter with its short- and long-option.
declare -g -a CSL_USER_PARAMS=()

# @var CSL_USER_PARAMS_VALUES
# @description this associatative array helds the values of plugin-specific
# getopt parameters that have been specified on the command-line as
# arguments to getopt parameters.
declare -g -A CSL_USER_PARAMS_VALUES=()

# @var CSL_USER_PARAMS_DEFAULT_VALUES
# @description this associatative array helds the default-values of plugin-
# specific getopt parameters that have been registered as getopt
# parameters. If no arguments are given to a specific getopt parameter,
declare -g -A CSL_USER_PARAMS_DEFAULT_VALUES=()

# @var CSL_USER_GETOPT_PARAMS
# @description this associatative array acts as fast lookup table from
# a specific getopt parameter (long or short), to the actually
# defined CSL_USER_PARAMS.
declare -g -A CSL_USER_GETOPT_PARAMS=()

# @var CSL_TEMP_DIRS
# @description this index array will be filled on any on any invocation of
# `create_tmpdir`, as that one will push the name of the created
# temp-directory to this variable. Later, `_csl_cleanup` will read
# this variable to take care of removing the previously created
# temporary directories, when the script finisheѕ.
declare -a CSL_TEMP_DIRS=()

# @var CSL_HELP_TEXT
# @description this variable heldѕ the plugin-specific help-text that can
# be set using `set_help_text` and overrules the libraries own
# help-text defined in CSL_DEFAULT_HELP_TEXT.
declare -g CSL_HELP_TEXT=''

# @var CSL_DEFAULT_HELP_TEXT
# @description this variable helds the libraries own default help-text. It
# can be overwritten by `set_help_text`.
declare -g CSL_DEFAULT_HELP_TEXT=''
# the '&& true' is required as read exits non-zero on reaching end-of-file
read -r -d '' CSL_DEFAULT_HELP_TEXT <<'EOF' && true
   -h, --help          ... help
   -d, --debug         ... enable debugging.
   -v, --verbose       ... be verbose.

   -w, --warning=arg   ... warning threshold, see below THRESHOLDS section.
   -c, --critical=arg  ... critical threshold, see below THRESHOLDS section.

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

Multiple thresholds can be specified comma separated. The syntax:

   key1=val1,key2=val2,key3=val3

* keyX is either the exact name of the counter value to be matched, or
a regular expression (regex) pattern.
* Regex patterns have to be surrounded by slashes: eg. /^http_resp/
* valX uses the above descriped THRESHOLD syntax. eg.

   http_status=403,^/http_resp/=5:10

EOF
readonly CSL_DEFAULT_HELP_TEXT

#
# </Variables>
#

#
# <Functions>
#

###############################################################################
#
# The next section contains functions where their scope is meant to be public.
# They are 'exported' to be accessed from the outside - best example:
# a monitoring plugin.
#
###############################################################################

# @function is_debug()
# @brief returns 0 if debugging is enabled, otherwise it returns 1.
# @return int 0 or 1
is_debug ()
{
   is_declared CSL_DEBUG || return 1;
   [ ${CSL_DEBUG} == ${CSL_TRUE} ] || return 1

   return 0
}
readonly -f is_debug

# @function debug()
# @brief prints output only if --debug or -d parameters have been given.
# debug output is sent to STDERR! The debug-output contains the function
# name from which debug() has been called (if no function -> 'main').
# Furthermore the line-number of the line that triggered debug() is
# displayed.
# @param1 string $debug_text
# @return int
debug ()
{
   is_debug || return 0;

   echo -e "${FUNCNAME[1]}([${BASH_LINENO[0]}]):\\t${1}" >&2
}
readonly -f debug

# @function fail()
# @brief prints the fail-text as well as the function and code-line from
# which it was called. The debug-output contains the function name from
# which debug() has been called (if no function -> 'main'). Furthermore
# the line-number of the line that triggered debug() is displayed.
# @param1 string $fail_text
# @return int
fail ()
{
   echo -e "${FUNCNAME[1]}([${BASH_LINENO[0]}]):\\t${1}"
}
readonly -f fail

# @function is_verbose()
# @brief returns 0 if verbose-logging is enabled, otherwise it returns 1.
# @return int 0 on success, 1 on failure
is_verbose ()
{
   is_declared CSL_VERBOSE || return 1;
   [ ${CSL_VERBOSE} == ${CSL_TRUE} ] || return 1

   return 0
}
readonly -f is_verbose

# @function verbose()
# @brief prints output only if --verbose or -v parameters have been given.
# verbose output is sent to STDERR!
# @param1 string $log_text
# @return int
verbose ()
{
   is_verbose || return 0;

   echo -e "${FUNCNAME[1]}([${BASH_LINENO[0]}]):\\t${1}" >&2
}
readonly -f verbose

# @function is_declared()
# @brief returns 0 if the provided variable has been declared (that
# does not mean, that the variable actually has a value!), otherwise
# it returns 1.
# @param1 string $var
# @return int 0 on success, 1 on failure
is_declared ()
{
   [ $# -eq 1 ] || return 1
   declare -p "${1}" &> /dev/null
   return "${?}"
}
readonly -f is_declared

# @function is_declared_func()
# @brief returns 0 if the provided function name refers to an
# already declared function. Otherwise it returns 1.
# @param1 string $var
# @return int 0 on success, 1 on failure
is_declared_func ()
{
   [ $# -eq 1 ] || return 1
   declare -p -f "${1}" &> /dev/null
   return "${?}"
}
readonly -f is_declared_func

# @function is_set()
# @brief returns 0, if all the provided values are set (non-empty string).
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
      ! is_empty_str "${PARAM}" || return 1;
      [ "${PARAM}" != "x" ] || return 1;
   done

   return 0
}
readonly -f is_set

# @function is_empty_str()
# @brief returns 0, if the provided string has a length of zero.
# Otherwise it returns 1.
# @param1 string $string
# @return int 0 on success, 1 on failure
is_empty_str ()
{
   [ $# -eq 1 ] || return 1
   [ -z "${1}" ] || return 1

   return 0
}
readonly -f is_empty_str

# @function is_empty()
# @brief returns 0, if the provided string or array variable have
# a value of length of zero.  Otherwise it returns 1.
# @param1 string|array $string
# @todo remove the call to is_empty_str() by 2017-12-31 and return
# an error if undeclared instead.
# @return int 0 on success, 1 on failure
is_empty ()
{
   [ $# -eq 1 ] || return 1

   if ! is_declared "${1}"; then
      is_empty_str "${1}"
      return "${?}"
   fi

   local -n VAR="${1}"

   if ! is_array "${1}"; then
      [ -z "${VAR}" ] || return 1
      return 0
   fi

   [ "${#VAR[@]}" -eq 0 ] || return 1

   return 0
}
readonly -f is_empty


# @function is_match()
# @brief invokes the Basic Calculator (bc) and provideѕ it the given $condition.
# If the condition is met, bc returns '1' - in this is_match() returns 0.
# Otherwise if the condition fails, bc will return '0', than is_match() returns 1.
# @param1 string $condition
# @return int 0 on success, 1 on failure
is_match ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty_str "${1}" || return 1

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
# @brief returns 0, if the given directory actually exists.
# Otherwise it returns 1.
# @param1 string $path
# @return int 0 on success, 1 on failure
is_dir ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty_str "${1}" || return 1
   [ -d "${1}" ] || return 1

   return 0
}
readonly -f is_dir

# @function eval_thresholds()
# @brief evaluates the given value $1 against WARNING ($2) and CRITICAL ($3) thresholds.
# @param1 string $value
# @param2 string $warning
# @param3 string $critical
# @output OK|WARNING|CRITICAL|UNKNOWN
# @return int 0|1|2|3
eval_thresholds ()
{
   [ $# -eq 3 ] || \
      { fail "eval_thresholds() requires 3 parameters."; return 1; }

   ( ! is_empty_str "${1}" && ! is_empty_str "${2}" && ! is_empty_str "${3}" ) || return 1

   local VALUE="${1}"
   local WARNING="${2}" WARN_MIN='' WARN_MAX=''
   local CRITICAL="${3}" CRIT_MIN='' CRIT_MAX=''
   local TEXT='' STATE='' MATCH=''

   read -r WARN_MIN WARN_MAX < <(_csl_get_threshold_range "${WARNING}")
   read -r CRIT_MIN CRIT_MAX < <(_csl_get_threshold_range "${CRITICAL}")

   if is_empty_str "${WARN_MIN}" || is_empty_str "${WARN_MAX}" || \
      is_empty_str "${CRIT_MIN}" || is_empty_str "${CRIT_MAX}"; then
      fail "something went wrong on parsing thresholds!"
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
   if is_set "${WARN_MIN}" "${WARN_MAX}" "${CRIT_MIN}" "${CRIT_MAX}" && \
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
   elif is_set "${CRIT_MIN}" "${CRIT_MAX}" && \
      is_match "${CRIT_MIN} <= ${CRIT_MAX}" && \
      is_match "${VALUE} >= ${CRIT_MIN}" && \
      is_match "${VALUE} <= ${CRIT_MAX}"; then
      TEXT="CRITICAL"
      STATE=${CSL_EXIT_CRITICAL}
      MATCH="inside-range-match"
   #
   # outside-range warning
   #
   elif is_set "${WARN_MIN}" "${WARN_MAX}" && \
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
   elif is_set "${CRIT_MIN}" "${CRIT_MAX}" && \
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
   elif ! is_set "${WARN_MIN}" && is_set "${WARN_MAX}" && \
      is_match "${VALUE} >= ${WARN_MAX}" &&
      is_match "${VALUE} < ${CRIT_MAX}"; then
      TEXT="WARNING"
      STATE=${CSL_EXIT_WARNING}
      MATCH="greater-than-or-equal-match"
   elif ! is_set "${CRIT_MIN}" && is_set "${CRIT_MAX}" && \
      is_match "${VALUE} >= ${CRIT_MAX}"; then
      TEXT="CRITICAL"
      STATE=${CSL_EXIT_CRITICAL}
      MATCH="greater-than-or-equal-match"
   #
   # finally check for less-than-or-equal (min)
   #
   elif ! is_set "${WARN_MAX}" && is_set "${WARN_MIN}" && \
      is_match "${VALUE} <= ${WARN_MIN}" &&
      is_match "${VALUE} > ${CRIT_MIN}"; then
      TEXT="WARNING"
      STATE=${CSL_EXIT_WARNING}
      MATCH="less-than-or-equal-match"
   elif ! is_set "${CRIT_MAX}" && is_set "${CRIT_MIN}" && \
      is_match "${VALUE} <= ${CRIT_MIN}"; then
      TEXT="CRITICAL"
      STATE=${CSL_EXIT_CRITICAL}
      MATCH="less-than-or-equal-match"
   else
      TEXT="OK"
      STATE=${CSL_EXIT_OK}
      MATCH="no-match-at-all"
   fi

   if is_empty_str "${MATCH}" || is_empty_str "${TEXT}" || is_empty_str "${STATE}"; then
      fail "something went horribly wrong."
      exit 1
   fi

   debug "RESULT: ${MATCH}, eval'd to ${TEXT}(${STATE})."
   echo "${TEXT}"
   return ${STATE}
}
readonly -f eval_thresholds

# @function eval_limits()
# @todo to be removed by 2017-12-31
# @deprecated true
eval_limits ()
{
   _csl_deprecate_func eval_thresholds "${@}"
}
readonly -f eval_limits

# @function eval_text()
# @brief evaluates the given text $1 against WARNING ($2) and CRITICAL ($3) thresholds.
# @param1 string $value
# @param2 string $warning
# @param3 string $critical
# @output OK|WARNING|CRITICAL|UNKNOWN
# @return int 0|1|2|3
eval_text()
{
   [ $# -eq 3 ] || \
      { fail "eval_text() requires 3 parameters."; return 1; }

   ( ! is_empty_str "${1}" && ! is_empty_str "${2}" && ! is_empty_str "${3}" ) || return 1

   local VALUE="${1}"
   local WARNING="${2}"
   local CRITICAL="${3}"
   local TEXT='' STATE='' MATCH=''

   if [ "${VALUE}" == "${WARNING}" ]; then
      TEXT="WARNING"
      STATE="${CSL_EXIT_WARNING}"
   elif [ "${VALUE}" == "${CRITICAL}" ]; then
      TEXT="CRITICAL"
      STATE="${CSL_EXIT_CRITICAL}"
   else
      TEXT="OK"
      STATE="${CSL_EXIT_OK}"
   fi

   debug "RESULT: eval'd to ${TEXT}(${STATE})."
   echo "${TEXT}"
   return ${STATE}
}
readonly -f eval_text

# @function is_range()
# @brief returns 0, if the argument given is in the form of an range.
# Otherwise it returns 1.
# @param1 string $range
# @return int 0 on success, 1 on failure
is_range ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty_str "${1}" || return 1

   if ! [[ "${1}" =~ ^(-?[[:digit:]]+[\.[:digit:]]*)?:(-?[[:digit:]]+[\.[:digit:]]*)?$ ]]; then
      return 1
   fi

   return 0
}
readonly -f is_range

# @function is_integer()
# @brief returns 0, if the given argument is an integer number.
# it also accepts the form :[0-9] (value lower than) and [0-9]: (value
# greater than). Otherwise it returns 1.
# @param1 string $integer
# @return int 0 on success, 1 on failure
is_integer ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty_str "${1}" || return 1
   [[ "${1}" =~ ^-?[[:digit:]]+$ ]] || return 1

   return 0
}
readonly -f is_integer

# @function is_float()
# @brief returns 0, if the given argument is a floating point number.
# Otherwise it returns 1.
# @param1 string $float
# @return int 0 on success, 1 on failure
is_float ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty_str "${1}" || return 1
   [[ "${1}" =~ ^-?[[:digit:]]+\.[[:digit:]]*$ ]] || return 1

   return 0
}
readonly -f is_float

# @function is_valid_threshold()
# @brief performs the checks on the given warning
# and critical values and returns 0, if they are.
# Otherwise it returns 1.
# @param1 string $threshold
# @return int 0 on success, 1 on failure
is_valid_threshold ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty_str "${1}" || return 1

   local THRESHOLD="${1}"

   # an integer
   if is_integer "${THRESHOLD}"; then
      return 0
   fi

   # a floating-point number (without exponent...)
   if is_float "${THRESHOLD}"; then
      return 0
   fi

   # a range
   if is_range "${THRESHOLD}"; then
      return 0
   fi

   # a word
   if is_word "${THRESHOLD}"; then
      return 0
   fi

   return 1
}
readonly -f is_valid_threshold

# @function is_valid_limit()
# @todo to be removed by 2017-12-31
# @deprecated true
is_valid_limit ()
{
   _csl_deprecate_func is_valid_threshold "${@}"
}
readonly -f is_valid_limit

# @function is_cmd()
# @brief returns 0, if the provided external command exists.
# Otherwise it returns 1.
# @param1 string $command
# @return int 0 on success, 1 on failure
is_cmd ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty_str "${1}" || return 1

   command -v "${1}" >/dev/null 2>&1;
   return "${?}"
}
readonly -f is_cmd

# @function is_func()
# @brief returns 0, if the given function name refers an already
# declared function. Otherwise it returns 1
# @param1 string $funcname
# @return int 0 on success, 1 on failure
is_func ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty_str "${1}" || return 1

   if [ "$(type -t "${1//[^a-zA-Z0-9_[:blank:][:punct:]]/}")" != "function" ]; then
      return 1
   fi

   return 0
}
readonly -f is_func

# @function set_result_text()
# @brief accepts the plugin-result either as first parameter,
# or reads it from STDIN (what allows heredoc usage for example).
# In case of STDIN, the read-timeout is set to 1 seconds.
# @param1 string $text
# @return int 0 on success, 1 on failure
set_result_text ()
{
   # the text might have been provided as first parameter.
   if [ $# -gt 1 ]; then
      fail "Invalid parameters"
      return 1
   fi

   if [ $# -ge 1 ]; then
      ! is_empty_str "${1}" || return 1
      CSL_RESULT_TEXT="${1}"
      return 0
   fi

   # otherwise we accept whatever is passed by STDIN
   read -r -d '' -t 1 CSL_RESULT_TEXT && true

   ! is_empty_str "${CSL_RESULT_TEXT}" || return 1
   return 0
}
readonly -f set_result_text

# @function has_result_text()
# @brief returns 0, if the plugin-result has already
# been set. Otherwise it returns 1.
# @return int 0 on success, 1 on failure
has_result_text ()
{
   is_declared CSL_RESULT_TEXT || return 1
   ! is_empty_str "${CSL_RESULT_TEXT}" || return 1

   return 0
}
readonly -f has_result_text

# @function get_result_text()
# @brief outputs the plugin-result, if it has already been set -
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
# @brief accepts the plugin-perfdata as first parameter.
# On success it returns 0, otherwise 1.
# @param1 string $perfdata
# @return int 0 on success, 1 on failure
set_result_perfdata ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty_str "${1}" || return 1

   CSL_RESULT_PERFDATA="${1}"
   return 0
}
readonly -f set_result_perfdata

# @function has_result_perfdata()
# @brief returns 0, if the plugin-perfdata has already
# been set. Otherwise it returns 1.
# @return int 0 on success, 1 on failure
has_result_perfdata ()
{
   is_declared CSL_RESULT_PERFDATA || return 1
   ! is_empty CSL_RESULT_PERFDATA || return 1

   return 0
}
readonly -f has_result_perfdata

# @function get_result_perfdata()
# @brief outputs the plugin-perfdata, if it has already
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
# @brief accepts the plugin-exit-code as first parameter.
# On success it returns 0, otherwise 1.
# @param1 string $exit_code
# @return int 0 on success, 1 on failure
set_result_code ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty_str "${1}" || return 1
   [[ "${1}" =~ ^[[:digit:]]{1,3}$ ]] || return 1

   # if the current result code is already set to something
   # higher than the provided code in $1, ignore it.
   if has_result_code && [ "${1}" -le "${CSL_RESULT_CODE}" ]; then
      return 0
   fi

   CSL_RESULT_CODE="${1}"
   return 0
}
readonly -f set_result_code

# @function has_result_code()
# @brief returns 0, if the plugin-code has already
# been set. Otherwise it returns 1.
# @return int 0 on success, 1 on failure
has_result_code ()
{
   is_declared CSL_RESULT_CODE || return 1
   ! is_empty CSL_RESULT_CODE || return 1
   [[ "${CSL_RESULT_CODE}" =~ ^[[:digit:]]{1,3}$ ]] || return 1

   return 0
}
readonly -f has_result_code

# @function get_result_code()
# @brief outputs the plugin-code, if it has already
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
# @brief outputs the final result as required for (c) Nagios,
# (c) Icinga, etc.
# @output plugin-result + plugin-perfdata
# @return int plugin-code
print_result ()
{
   local RESULT PERFDATA
   readonly STOP_TIME_PLUGIN="$(date +%s%3N)"

   if ! is_empty_str "${START_TIME_PLUGIN}" && ! is_empty_str "${STOP_TIME_PLUGIN}"; then
      ((DIFF_TIME_PLUGIN = STOP_TIME_PLUGIN - START_TIME_PLUGIN))
      local CYCLE_TIME=" plugin_time=${DIFF_TIME_PLUGIN}ms"
   fi

   if ! has_result_text || ! has_result_code; then
      echo "Plugin state is UNKNOWN!"
      ! _csl_is_exit_on_no_data_critical || exit ${CSL_EXIT_CRITICAL}
      exit ${CSL_EXIT_UNKNOWN}
   fi

   RESULT="$(get_result_text)"

   if ! has_result_perfdata; then
      echo "${RESULT}"
      exit "$(get_result_code)"
   fi

   PERFDATA="$(get_result_perfdata)${CYCLE_TIME-}"
   echo "${RESULT}|${PERFDATA}"
   exit "$(get_result_code)"
}
readonly -f print_result

# @function show_help()
# @brief displays the help text.
#
# If a plugin-specifc help-text has been set via set_help_text(),
# that one is printed. Otherwise this libraries $CSL_DEFAULT_HELP_TEXT
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

# @function startup()
# @brief is the first library function, that any plugin should invoke.
# @param1 string $cmdline_params
# @output plugin-result + plugin-perfdata
# @return int 0 on success, 1 on failure
startup ()
{
   readonly START_TIME_PLUGIN="$(date +%s%3N)"

   _csl_check_requirements || \
      { echo "_csl_check_requirements() returned non-zero!"; exit 1; }
   _csl_parse_parameters "${@}" || \
      { echo "_csl_parse_parameters() returned non-zero!"; exit 1; }
   _csl_validate_parameters || \
      { echo "_csl_validate_parameters() returned non-zero!"; exit 1; }

   if is_func plugin_startup; then
      plugin_startup;
   fi

   if ! is_declared_func plugin_worker || ! is_func plugin_worker; then
      fail "There is no plugin_worker() function defined by your plugin!"
      return 1
   fi

   plugin_worker "${@}" || \
      { echo "plugin_worker() returned non-zero!"; exit 1; }

   print_result || \
      { echo "print_result() returned non-zero!"; exit 1; }

   return 0
}
readonly -f startup

# @function set_help_text()
# @brief accepts a plugin-specific help-text, that is
# returned when show_help() is called.
#
# The text can either be provided as first parameter or being read
# from STDIN (what allows heredoc usage for example).
# @param1 string $text
# @return int 0 on success, 1 on failure
set_help_text ()
{
   # the text might have been provided as first parameter.
   if [ $# -ge 1 ]; then
      ! is_empty_str "${1}" || return 1
      CSL_HELP_TEXT="${1}"
      return 0
   fi

   # otherwise we accept whatever is passed by STDIN
   read -r -d '' -t 1 CSL_HELP_TEXT && true

   ! is_empty CSL_HELP_TEXT || return 1
   return 0
}
readonly -f set_help_text

# @function has_help_text()
# @brief returns 0, if a plugin-specific help-text has been set.
# Otherwise it returns 1.
# @return int 0 on success, 1 on failure
has_help_text ()
{
   is_declared CSL_HELP_TEXT || return 1
   ! is_empty CSL_HELP_TEXT || return 1

   return 0
}
readonly -f has_help_text

# @function get_help_text()
# @brief outputs a plugin-specific help-text, if it has been previously
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
   if [ $# -lt 3 ] || [ $# -gt 4 ]; then
      fail "Invalid parameters"
      return 1
   fi

   local GETOPT_SHORT="${1}"
   local GETOPT_LONG="${2}"
   local GETOPT_HAS_ARGS=''
   local OPT_VAR="${3}"
   [ $# -eq 4 ] && local OPT_DEFAULT="${4}"

   if is_empty_str "${GETOPT_SHORT}" && is_empty_str "${GETOPT_LONG}"; then
      fail "at least a short or a long option name has to be provided."
      return 1
   fi

   if ! is_empty_str "${GETOPT_SHORT}"; then
      if  ! [[ "${GETOPT_SHORT}" =~ ^-?([[:alnum:]])(:?:?)$ ]]; then
         fail "given short parameter is invalid."
         return 1
      fi
      GETOPT_SHORT="${BASH_REMATCH[1]}"
      [ ${#BASH_REMATCH[@]} -eq 3 ] && GETOPT_HAS_ARGS="${BASH_REMATCH[2]}"
   fi

   if ! is_empty_str "${GETOPT_LONG}"; then
      if ! [[ "${GETOPT_LONG}" =~ ^-?-?([[:alnum:]]+)(:?:?)$ ]]; then
         fail "given long parameter is invalid."
         return 1
      fi
      GETOPT_LONG="${BASH_REMATCH[1]}"
      [ ${#BASH_REMATCH[@]} -eq 3 ] && GETOPT_HAS_ARGS="${BASH_REMATCH[2]}"
   fi

   if has_param "${OPT_VAR}"; then
      fail "Variable ${OPT_VAR} is already declared."
      return 1
   fi

   if ! is_empty_str "${GETOPT_SHORT}"; then
      CSL_USER_GETOPT_PARAMS["${GETOPT_SHORT}"]="${OPT_VAR}"
      CSL_GETOPT_SHORT+="${GETOPT_SHORT}${GETOPT_HAS_ARGS}"
   fi

   if ! is_empty_str "${GETOPT_LONG}"; then
      CSL_USER_GETOPT_PARAMS["${GETOPT_LONG}"]="${OPT_VAR}"
      CSL_GETOPT_LONG+="${GETOPT_LONG}${GETOPT_HAS_ARGS},"
   fi

   # intialize the parameter with an empty value.
   CSL_USER_PARAMS+=( "${OPT_VAR}" )
   CSL_USER_PARAMS_VALUES["${OPT_VAR}"]=""

   if is_declared OPT_DEFAULT; then
      CSL_USER_PARAMS_DEFAULT_VALUES["${OPT_VAR}"]="${OPT_DEFAULT}"
   fi

   #echo "Added parameter ${OPT_VAR}: short:${GETOPT_SHORT-}${GETOPT_HAS_ARGS}, long:${GETOPT_LONG-}${GETOPT_HAS_ARGS}"
   return 0
}
readonly -f add_param

# @function has_param()
# @brief returns 0, if the given parameter name actually is defined.
# Otherwise it returns 1.
# @param1 string $param
# @return int 0 on success, 1 on failure
has_param ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty_str "${1}" || return 1

   if ! in_array CSL_USER_PARAMS "${1}"; then
      return 1
   fi

   return 0
}
readonly -f has_param

# @function has_param_value()
# @brief returns 0, if the given parameter has been defined
# and consists of a value that is not empty. Otherwise it returns 1.
# It also considers a default-value and returns true if that
# one is present.
# @param1 string $param
# @return int 0 on success, 1 on failure
#
has_param_value ()
{
   if [ $# -ne 1 ] || is_empty_str "${1}"; then
      fail "Invalid parameters"
      return 1
   fi

   if ! has_param "${1}"; then
      fail "There is no such parameter"
      return 1
   fi

   if ! has_param_custom_value "${1}"; then
      if has_param_default_value "${1}"; then
         return  0
      fi

      return 1
   fi

   return 0
}
readonly -f has_param_value

# @function has_param_custom_value()
# @brief returns 0, if the given parameter has been defined
# and consists of a custom-value that is not empty.
# Otherwise it returns 1.
# @param1 string $param
# @return int 0 on success, 1 on failure
has_param_custom_value ()
{
   if [ $# -ne 1 ] || is_empty_str "${1}"; then
      fail "Invalid parameters"
      return 1
   fi

   if ! has_param "${1}"; then
      fail "There is no such parameter"
      return 1
   fi

   [[ -v "CSL_USER_PARAMS_VALUES[${1}]" ]] || return 1

   if is_empty_str "${CSL_USER_PARAMS_VALUES[${1}]}"; then
      return 1
   fi

   return 0
}
readonly -f has_param_value

# @function has_param_default_value()
# @brief returns 0, if the given parameter has been defined
# and consists of a default-value that is not empty.
# Otherwise it returns 1.
# @param1 string $param
# @return int 0 on success, 1 on failure
has_param_default_value ()
{
   if [ $# -ne 1 ] || is_empty_str "${1}"; then
      fail "Invalid parameters"
      return 1
   fi

   if ! has_param "${1}"; then
      fail "There is no such parameter"
      return 1
   fi

   [[ -v "CSL_USER_PARAMS_DEFAULT_VALUES[${1}]" ]] || return 1

   if is_empty_str "${CSL_USER_PARAMS_DEFAULT_VALUES[${1}]}"; then
      return 1
   fi

   return 0
}
readonly -f has_param_value


# @function get_param_value()
# @brief outputs the value of a given parameter, if it has
# been set already - in this case it returns 0. Otherwise it returns 1.
# @param1 string $param
# @return int 0 on success, 1 on failure
get_param_value ()
{
   if [ $# -ne 1 ] || is_empty_str "${1}"; then
      fail "Invalid parameters"
      return 1
   fi

   if ! has_param "${1}"; then
      fail "There is no such parameter"
      return 1
   fi

   if ! has_param_value "${1}"; then
      fail "Parameter has no value set"
      return 1
   fi

   if ! has_param_custom_value "${1}"; then
      if ! has_param_default_value "${1}"; then
         fail "Parameter has no value set"
         return 1
      fi

      get_param_default_value "${1}"
      return 0
   fi

   get_param_custom_value "${1}"
   return 0
}
readonly -f get_param_value

# @function get_param_custom_value()
# @brief outputs the value of a given parameter, if it has
# been set already - in this case it returns 0. Otherwise it returns 1.
# @param1 string $param
# @return int 0 on success, 1 on failure
get_param_custom_value ()
{
   if [ $# -ne 1 ] || is_empty_str "${1}"; then
      fail "Invalid parameters"
      return 1
   fi

   if ! has_param "${1}"; then
      fail "There is no such parameter"
      return 1
   fi

   if ! has_param_custom_value "${1}"; then
      fail "Parameter has no value set"
      return 1
   fi

   echo "${CSL_USER_PARAMS_VALUES[${1}]}"
   return 0
}
readonly -f get_param_custom_value

# @function get_param_default_value()
# @brief outputs the default value of a given parameter, if it has
# been set already - in this case it returns 0. Otherwise it returns 1.
# @param1 string $param
# @return int 0 on success, 1 on failure
get_param_default_value ()
{
   if [ $# -ne 1 ] || is_empty_str "${1}"; then
      fail "Invalid parameters"
      return 1
   fi

   if ! has_param "${1}"; then
      fail "There is no such parameter"
      return 1
   fi

   if ! has_param_default_value "${1}"; then
      fail "Parameter has no default-value set"
      return 1
   fi

   echo "${CSL_USER_PARAMS_DEFAULT_VALUES[${1}]}"
   return 0
}
readonly -f get_param_default_value


# @function get_param()
# @brief works similar as get_param_value(), but it also
# accepts the short- (eg. -w) and long-parameters (eg. --warning)
# as indirect lookup keys. On success, the value is printed and
# the function returns 0. Otherwise it returns 1.
# @param1 string $param
# @output param-value
# @return int 0 on success, 1 on failure
get_param ()
{
   if [ $# -ne 1 ] || is_empty_str "${1}"; then
      fail "Invalid parameters"
      return 1
   fi

   #
   # in case the 1:1 name of a parameter has been provided
   #
   if [[ "${1}" =~ ^[[:alnum:]_]+$ ]]; then
      if ! has_param "${1}"; then
         fail "There is no such parameter"
         return 1
      fi

      if ! has_param_value "${1}"; then
         fail "Parameter has no value set"
         return 1
      fi

      get_param_value "${1}"
      return 0
   fi

   #
   # lookup the parameter via the getopt key (short or long form)
   #
   if ! [[ "${1}" =~ ^-?-?[[:alnum:]]+$ ]]; then
      fail "Invalid parameters"
      return 1
   fi

   if ! [[ -v "CSL_USER_GETOPT_PARAMS[${1}]" ]]; then
      fail "There is no such parameter"
      return 1
   fi

   local KEY="${CSL_USER_GETOPT_PARAMS[${1}]}"

   if ! has_param_value "${KEY}"; then
      if ! has_param_default_value "${KEY}"; then
         fail "No value has been set"
         return 1
      fi

      get_param_default_value "${KEY}"
      return 0
   fi

   get_param_value "${KEY}"
   return 0
}
readonly -f get_param

# @function add_prereq()
# @brief registers a new plugin-requesit. Those are
# then handled in _csl_check_requirements(). On success
# the function returns 0, otherwise it returns 1.
#
# Multiple requesits can be registered in one step.
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

# @function create_tmpdir()
# @brief creates and tests for a temporary directory
# being created by mktemp.
# Furthermore it registers the temp-directory in the variable
# CSL_TEMP_DIRS[] that is eval'ed in case by _csl_cleanup(), to
# remove plugin residues.
# there is a hard-coded threshold for max. 10 temp-directories.
# @output temp-directory
# @return int 0 on success, 1 on failure
create_tmpdir ()
{
   local CSL_TMPDIR='' RETVAL=''

   if [ ${#CSL_TEMP_DIRS[@]} -gt 10 ]; then
      fail "I am not willing to create more than 10 temp-directories for you!"
      exit 1
   fi

   CSL_TMPDIR="$(mktemp -d -p /tmp csl.XXXXXX)"
   RETVAL="${?}"

   if [ "x${RETVAL}" != "x0" ]; then
      fail "mktemp exited non-zero!";
      exit 1
   fi

   if is_empty_str "${CSL_TMPDIR}"; then
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
# @brief registers a signal-trap for certain signals like
# EXIT and INT, to call the _csl_cleanup() function on program-termination
# (irrespectivly of success or failure).
#
# Note that the cleanup trap must be installed from the plugin.
# As mostly these libraries functions will be called within a subshell
# (eg. $(create_tmpdir)), the trap would only life within the context
# of this subshell and would immediately be fired as soon as create_tmpdir()
# finish.
# @return int 0 on success, 1 on failure
setup_cleanup_trap ()
{
   #
   # has the cleanup trap already been installed
   #
   #if trap -p | grep -qsE "^trap[[:blank:]]--[[:blank:]]'_csl_cleanup'[[:blank:]]"; then
   if [[ "$(trap -p)" =~ ^trap[[:blank:]]--[[:blank:]]'_csl_cleanup'[[:blank:]] ]]; then
      return 0
   fi

   trap _csl_cleanup INT QUIT TERM EXIT
   return "${?}"
}
readonly -f setup_cleanup_trap

# @function sanitize()
# @brief This function tries to sanitize the provided string
# and removes all characters from the string that are not
# matching the provided pattern mask.
# @param1 string text
# @output string
# @return int
sanitize ()
{
   # exactly one argument is required.
   [ $# -eq 1 ] || return 1
   # zero-strings we can skip.
   [ ! -z "${1}" ] || return 0
   local SANI="${1}"
   # strip of any control characters.
   SANI="${SANI//[[:cntrl:]]/}"
   #SANI="${SANI//[\x01-\x1F\x7F]/}"
   # strip of any backslash sequence.
   SANI="${SANI//\\[:alnum:]/}"
   # ensure the script only contains printable characters and blanks.
   SANI="${SANI//^+([^[:alnum:][:punct:][:blank:]])$/}"

   echo "${SANI}"
   return 0
}
readonly -f sanitize

# @function in_array()
# @brief searches the array $1 for the value given in $2.
# $2 may even contain a regular expression pattern.
# On success, it returns 0. Otherwise 1 is returned.
# @param1 string array-name
# @param2 string needle
# @return int
in_array ()
{
   if [ $# -ne 2 ] || \
      ! [[ "${1}" =~ ^[[:graph:]]+$ ]] || \
      ! is_array "${1}"; then
      fail "Invalid parameters"
      return 1
   fi

   local -n haystack="${1}"

   for i in "${haystack[@]}"; do
      if [[ "${i}" =~ ${2} ]]; then
         return 0
      fi
   done

   return 1
}
readonly -f in_array

# @function in_array_re()
# @brief This function works similar as in_array(), but uses the
# patterns that have been stored in the array $1 against the fixed
# string provided with $2.
# On success, it returns 0. Otherwise 1 is returned.
# @param1 string array-name
# @param2 string needle
# @return int
in_array_re ()
{
   if [ $# -ne 2 ] || \
      ! [[ "${1}" =~ ^[[:graph:]]+$ ]] || \
      ! is_array "${1}"; then
      fail "Invalid parameters"
      return 1
   fi

   local -n haystack="${1}"
   #local -a 'haystack=("${'"${1}"'[@]}")'

   for i in "${haystack[@]}"; do
      if [[ "${2}" =~ ${i} ]]; then
         return 0
      fi
   done

   return 1
}
readonly -f in_array_re

# @function key_in_array()
# @brief searches the associatative array $1 for the key given in $2.
# $2 may even contain a regular expression pattern.
# On success, it returns 0. Otherwise 1 is returned.
# @param1 string array-name
# @param2 string needle
# @return int
key_in_array ()
{
   if [ $# -ne 2 ] || \
      ! [[ "${1}" =~ ^[[:graph:]]+$ ]] || \
      ! is_array "${1}"; then
      fail "Invalid parameters"
      return 1
   fi

   local -n haystack="${1}"

   for i in "${!haystack[@]}"; do
      if [[ "${i}" =~ ${2} ]]; then
         return 0
      fi
   done

   return 1
}
readonly -f key_in_array

# @function key_in_array_re()
# @brief This function works similar as key_in_array(), but uses the
# patterns that have been stored in the array $1 against the fixed
# string provided with $2.
# On success, it returns 0. Otherwise 1 is returned.
# @param1 string array-name
# @param2 string needle
# @return int
key_in_array_re ()
{
   if [ $# -ne 2 ] || \
      ! [[ "${1}" =~ ^[[:graph:]]+$ ]] || \
      ! is_array "${1}"; then
      fail "Invalid parameters"
      return 1
   fi

   local -n haystack="${1}"

   for i in "${!haystack[@]}"; do
      if [[ "${2}" =~ ${i//\//} ]]; then
         return 0
      fi
   done

   return 1
}
readonly -f key_in_array_re

# @function is_array()
# @brief This function tests if the provided array
# $1 is either an indexed- or an associative-array.
# If so, the function returns 0, otherwise 1.
# @param1 string array-name
# @return int
is_array ()
{
   [ $# -eq 1 ] || return 1
   [[ "${1}" =~ ^[[:graph:]]+$ ]] || return 1

   if ! [[ "$(declare -p "${1}" 2>&1)" =~ ^declare[[:blank:]]+-(a|A)r?[[:blank:]]+ ]]; then
      return 1
   fi

   return 0
}
readonly -f is_array

# @function is_word()
# @brief This function tests if the provided string
# contains only alpha-numeric characters.
is_word ()
{
   [ $# -eq 1 ] || return 1
   [[ "${1}" =~ ^[[:alnum:]]+$ ]] || return 1

   return 0
}
readonly -f is_word

# @function has_threshold()
# @brief This function checks, if a threshold has been registered for the provided
# key ($1)
# @param1 string key
# @return int 0 on success, 1 on failure
has_threshold ()
{
   if [ $# -ne 1 ] || \
      is_empty_str "${1}" || \
      ! [[ "${1}" =~ ^[[:graph:]]+$ ]]; then
      fail "Invalid parameters"
      return 1
   fi

   # it is enough to check against the warning-threshold, as we took care in
   # _csl_validate_parameters() that a corresponding critical-threshold has been
   # set too.
   [[ -v "CSL_WARNING_THRESHOLD[${1}]" ]] || return 1

   return 0
}
readonly -f has_threshold

# @function has_limit()
# @todo to be removed by 2017-12-31
# @deprecated true
has_limit ()
{
   _csl_deprecate_func has_threshold "${@}"
}
readonly -f has_limit

# @function get_threshold_for_key()
# @brief This function look up the declared warning- or critical-thresholds ($1)
# for the specified key ($2).
# @param1 string Either 'WARNING' or 'CRITICAL'
# @param2 string key name
# @output text threshold
# @return int 0 on success, 1 on failure
get_threshold_for_key ()
{
   if [ $# -ne 2 ] || \
      is_empty_str "${1}" || \
      is_empty_str "${2}" || \
      ! [[ "${1}" =~ ^(WARNING|CRITICAL)$ ]] || \
      ! [[ "${2}" =~ ^[[:graph:]]+$ ]]; then
      fail "Invalid parameters"
      return 1
   fi

   if ! key_in_array_re "CSL_${1}_THRESHOLD" "${2}"; then
      return 1
   fi

   local -n THRESHOLD="CSL_${1}_THRESHOLD"

   for KEY in "${!THRESHOLD[@]}"; do
      if [[ "${2}" =~ ${KEY//\//} ]]; then
         echo "${THRESHOLD[${KEY}]}"
         return 0
      fi
   done

   return 1
}
readonly -f get_threshold_for_key

# @function get_limit_for_key()
# @todo to be removed by 2017-12-31
# @deprecated true
get_limit_for_key ()
{
   _csl_deprecate_func get_threshold_for_key "${@}"
}
readonly -f get_limit_for_key

# @function add_result()
# @brief This function registers a result value ($2) for the given
# key ($1). The function does not allow to overrule an already set
# value with the same key.
# @param1 string key name
# @param2 string value
# @return int 0 on success, 1 on failure
add_result ()
{
   if [ $# -ne 2 ] || \
      is_empty_str "${1}" || \
      is_empty_str "${2}" || \
      ! [[ "${1}" =~ ^[[:graph:]]+$ ]] || \
      ! [[ "${2}" =~ ^[[:print:]]+$ ]]; then
      fail "Invalid parameters"
      return 1
   fi

   local KEY="${1}"
   local VAL="${2}"

   if [[ -v "CSL_RESULT_VALUES[${KEY}]" ]]; then
      fail "A value for '${KEY}' has already been set!"
      return 1
   fi

   CSL_RESULT_VALUES["${KEY}"]="${VAL}"
   return 0
}
readonly -f add_result

# @function has_results()
# @brief This function performs a quick check, if actually result values
# have been recorded.
# @return int 0 on success, 1 on failure
has_results ()
{
   is_declared CSL_RESULT_VALUES || return 1
   is_array CSL_RESULT_VALUES || return 1
   [ "${#CSL_RESULT_VALUES[@]}" -ge 1 ] || return 1

   return 0
}
readonly -f has_results

# @function has_result()
# @brief This function tests if a result has been recorded for the given
# key ($1).
# @return int 0 on success, 1 on failure
has_result ()
{
   if [ $# -ne 1 ] || \
      is_empty_str "${1}" || \
      ! [[ "${1}" =~ ^[[:graph:]]+$ ]]; then
      fail "Invalid parameters"
      return 1
   fi

   has_results || return 1
   [[ -v "CSL_RESULT_VALUES[${1}]" ]] || return 1

   return 0
}
readonly -f has_result

# @function get_result()
# @brief This function returns the result that has been recorded for the
# given key ($1).
# @output string value
# @param1 string key name
# @return int 0 on success, 1 on failure
get_result ()
{
   if [ $# -ne 1 ] || \
      is_empty_str "${1}" || \
      ! [[ "${1}" =~ ^[[:graph:]]+$ ]]; then
      fail "Invalid parameters"
      return 1
   fi

   has_result "${1}" || return 1

   echo "${CSL_RESULT_VALUES[${1}]}"
   return 0
}
readonly -f get_result

# @function eval_results()
# @brief This function iterates over all the recorded results and
# evaluate their values with eval_thresholds(). Finally, the function
# uses set_result_(text|code|perfdata) to set the plugins final
# results.
#
# To perform your own evaluations, you may override this function
# by specifying an user_eval_results() function in your plugin.
# Than plugin_worker() will _not_ call eval_results(), but invokes
# user_eval_results() instead.
# @return 0 on success, 1 on failure
eval_results ()
{
   local KEY='' VAL='' WARNING='' CRITICAL='' THRESHOLD_KEY=''
   local RESULT_TEXT='' RESULT_PERF='' RESULT_CODE=0
   local RESULT='' RETVAL=0
   # @description with $KEYS_HANDLED we just keep track to later test,
   # for which keys thresholds are set, but no results are available
   # for them.
   declare -g -a KEYS_HANDLED=()

   if ! has_results; then
      set_result_text "No plugin results are available."
      _csl_is_exit_on_no_data_critical && RESULT_CODE="${CSL_EXIT_CRITICAL}" || RESULT_CODE="${CSL_EXIT_UNKNOWN}"
      set_result_code "${RESULT_CODE}"
      # no perfdata gets set in this case.
      return 0
   fi

   for KEY in "${!CSL_RESULT_VALUES[@]}"; do
      ! is_empty_str "${KEY}" || continue
      KEYS_HANDLED+=( "${KEY}" )
      has_result "${KEY}" || continue

      #
      # check if a threshold for the specific key has actually been specified,
      # otherwise we check, if there is only one threshold been given at all - then
      # it is used for all values. And if not, the value is totally skipped.
      #
      # it is enough to check against the warning-threshold, as we took care in
      # _csl_validate_parameters() that a corresponding critical-threshold has
      # been set too.
      #
      if key_in_array_re CSL_WARNING_THRESHOLD "${KEY}"; then
         THRESHOLD_KEY="${KEY}"
      else
         if ! has_threshold "key0"; then
            verbose "No threshold set for '${KEY}'. Ignoring it."
            continue
         fi
         THRESHOLD_KEY="key0"
      fi

      #
      # retrieve the warning- and critical-thresholds for the specific key.
      #
      WARNING="$(get_threshold_for_key WARNING "${THRESHOLD_KEY}")"
      CRITICAL="$(get_threshold_for_key CRITICAL "${THRESHOLD_KEY}")"

      if is_empty_str "${WARNING}" || is_empty_str "${CRITICAL}"; then
         fail "Unable to retrieve thresholds for '${KEY}'!"
         return 1
      fi

      VAL="$(get_result "${KEY}")"
      DISPLAY_VAL="${VAL}"

      #
      # the retrieved result-value may contain a unit-of-measure.
      # in this, extract only the numeric value from it.
      #
      if [[ "${VAL}" =~ ^(-?[[:digit:]]+[\.[:digit:]]*)[[:print:]]*$ ]]; then
         VAL="${BASH_REMATCH[1]}"
      fi

      debug "${KEY} value: ${VAL} (${DISPLAY_VAL})"
      debug "${KEY} warning: ${WARNING}"
      debug "${KEY} critical: ${CRITICAL}"

      # if the original value was consist of digits and unit-of-measure, only
      # the digits should now be present in $VAL. If there is still text, we
      # have to evaluate it text-based.
      if [[ "${VAL}" =~ [[:alpha:]] ]]; then
         RESULT="$(eval_text "${VAL}" "${WARNING}" "${CRITICAL}")" && RETVAL="${?}" || RETVAL="${?}"
      else
         RESULT="$(eval_thresholds "${VAL}" "${WARNING}" "${CRITICAL}")" && RETVAL="${?}" || RETVAL="${?}"
      fi

      if [ $RETVAL -gt ${RESULT_CODE} ]; then
         RESULT_CODE="${RETVAL}"
      fi

      debug "${KEY} result text: ${RESULT}"
      debug "${KEY} result code: ${RESULT_CODE}"

      RESULT_TEXT+="${KEY}:${DISPLAY_VAL}(${RESULT}), "

      # for text-based results, we do not add performance-counters.
      if ! [[ "${VAL}" =~ [[:alpha:]] ]]; then
         RESULT_PERF+="${KEY}=${VAL};${WARNING};${CRITICAL} "
      fi
   done

   #
   # If CSL_EXIT_NO_DATA_IS_CRITICAL is set, reverse check, if for all
   # declared thresholds, an input value has been found. Otherwise a missing
   # one will lead to a critical exit-state.
   #
   if _csl_is_exit_on_no_data_critical; then
      for KEY in "${!CSL_WARNING_THRESHOLD[@]}"; do
         in_array KEYS_HANDLED "${KEY//\//}" && continue
         RESULT_TEXT+="${KEY}:n/a(CRITICAL), "
         RESULT_CODE="${CSL_EXIT_CRITICAL}"
      done
   fi

   debug "Handled keys: ${KEYS_HANDLED[*]}"
   unset KEYS_HANDLED

   if is_empty_str "${RESULT_TEXT}"; then
      fail "No plugin results have been evaluated!"
      return 1
   fi

   set_result_text "${RESULT_TEXT:0:-2}"
   set_result_code "${RESULT_CODE}"
   set_result_perfdata "${RESULT_PERF:0:-1}"
}
readonly -f eval_results

# @function exit_no_data()
# @brief This function can be called to exit with the correct
# exit-code, in case no plugin data is available. The function
# outputs CSL_EXIT_CRITICAL if CSL_EXIT_NO_DATA_IS_CRITICAL is
# set, otherwise it returns CSL_EXIT_UNKNOWN
# @return int 0 on success
# @output int CSL_EXIT_CRITICAL or CSL_EXIT_UNKNOWN
# @example exit "$(exit_no_data)"
exit_no_data ()
{
   ! _csl_is_exit_on_no_data_critical || echo "${CSL_EXIT_CRITICAL}"

   echo "${CSL_EXIT_UNKNOWN}"
   return 0
}
readonly -f exit_no_data

###############################################################################
#
#
# Functions which scope is meant to be private - those are for value to this
# library only. Usually there is no reason to access those functions from
# external.
#
# To indicate this private context, those functions are prefixed by '_csl_'.
#
###############################################################################

# @function _csl_is_exit_on_no_data_critical()
# @brief returns 0, if it has been choosen, that no-data-is-available is
# a critical error. otherwise it returns 1.
# @return int 0 on success, 1 on failure
_csl_is_exit_on_no_data_critical ()
{
   is_declared CSL_EXIT_NO_DATA_IS_CRITICAL || return 1
   ! is_empty CSL_EXIT_NO_DATA_IS_CRITICAL || return 1
   ${CSL_EXIT_NO_DATA_IS_CRITICAL} || return 1
   return 0
}
readonly -f _csl_is_exit_on_no_data_critical

# @function _csl_check_requirements()
# @brief tests for other required tools. It also invokes an possible
# plugin-specific requirement-check function called plugin_prereq().
# @return int 0 on success, 1 on failure
_csl_check_requirements ()
{
   local RETVAL=0

   # is Bash actually used?
   if ! is_declared BASH_VERSINFO || is_empty_str "${BASH_VERSINFO[0]}"; then
      fail "Strangely BASH_VERSINFO variable is not (correctly) set!"
      exit ${CSL_EXIT_CRITICAL}
   fi

   # Bash major version 4 or later is required
   if [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
      fail "BASH version 4.3 or greater is required!"
      return ${CSL_EXIT_CRITICAL}
   fi

   # If bash major version 4 is used, the minor needs to be 3 or greater (for [[ -v ]] tests).
   if [ "${BASH_VERSINFO[0]}" -eq "4" ] && [ "${BASH_VERSINFO[1]}" -lt "3" ]; then
      fail "BASH version 4.3 or greater is required!"
      return ${CSL_EXIT_CRITICAL}
   fi

   local PREREQ

   for PREREQ in "${CSL_DEFAULT_PREREQ[@]}" "${CSL_USER_PREREQ[@]}"; do
      is_cmd "${PREREQ}" || { fail "Unable to locate '${PREREQ}' binary!"; return 1; }
   done

   if is_func plugin_prereq; then
      plugin_prereq;
      RETVAL="${?}"
   fi

   return $RETVAL
}
readonly -f _csl_check_requirements

# @function _csl_get_threshold_range()
# @brief returns the provided threshold as range in the form of
# 'MIN MAX'. In case the provided value is a single value (either
# integer or float), then 'x MAX' is returned.
# @param1 string $threshold
# @output string
# @return int 0 on success, 1 on failure
_csl_get_threshold_range ()
{
   [ $# -eq 1 ] || return 1
   ! is_empty_str "${1}" || return 1
   local THRESHOLD="${1}"

   # for ordinary numbers as threshold
   if is_integer "${THRESHOLD}" || is_float "${THRESHOLD}"; then
      echo "x ${THRESHOLD}"
      return 0
   fi

   if ! [[ ${THRESHOLD} =~ ^(-?[[:digit:]]+[\.[:digit:]]*)?:(-?[[:digit:]]+[\.[:digit:]]*)?$ ]]; then
      fail "That does not look like a threshold-range at all!"
      return 1
   fi

   local THRESHOLD_MIN="x"
   if ! is_empty_str "${BASH_REMATCH[1]}"; then
      THRESHOLD_MIN="${BASH_REMATCH[1]}"
   fi

   local THRESHOLD_MAX="x"
   if ! is_empty_str "${BASH_REMATCH[2]}"; then
      THRESHOLD_MAX="${BASH_REMATCH[2]}"
   fi

   echo "${THRESHOLD_MIN} ${THRESHOLD_MAX}"
   return 0
}
readonly -f _csl_get_threshold_range

# @function _csl_get_limit_range()
# @todo to be removed by 2017-12-31
# @deprecated true
_csl_get_limit_range ()
{
   _csl_deprecate_func _csl_get_threshold_range "${@}"
}
readonly -f _csl_get_limit_range



# @function _csl_parse_parameters()
# @brief This function uses GNU getopt to parse the given command-line
# parameters.
# @param1 string $params
# @return int 0 on success, 1 on failure
_csl_parse_parameters ()
{
   local TEMP='' RETVAL=''
   local GETOPT_SHORT="${CSL_DEFAULT_GETOPT_SHORT}"
   local GETOPT_LONG="${CSL_DEFAULT_GETOPT_LONG}"
   local NO_PARAMS_IS_OK=false

   if is_declared CSL_WARNING_THRESHOLD_DEFAULT && ! is_empty CSL_WARNING_THRESHOLD_DEFAULT && \
      is_declared CSL_CRITICAL_THRESHOLD_DEFAULT && ! is_empty CSL_CRITICAL_THRESHOLD_DEFAULT; then
      NO_PARAMS_IS_OK=true
   fi

   if [ $# -lt 1 ] && ! ${NO_PARAMS_IS_OK}; then
      fail "Parameters required!"
      echo
      show_help
      exit 1
   fi

   if _csl_has_short_params; then
      TEMP="$(_csl_get_short_params)"

      if ! is_empty_str "${TEMP}"; then
         GETOPT_SHORT+="${TEMP}"
      fi
   fi

   if _csl_has_long_params; then
      TEMP=$(_csl_get_long_params)

      if ! is_empty_str "${TEMP}" ; then
         GETOPT_LONG+=",${TEMP}"
      fi
   fi

   TEMP=$(getopt -n "${FUNCNAME[0]}" -o "${GETOPT_SHORT}" --long "${GETOPT_LONG}" -- "${@}")
   RETVAL="${?}"

   if [ "x${RETVAL}" != "x0" ] || \
     is_empty_str "${TEMP}" || \
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
      case "${1}" in
         '-h'|'--help')
            show_help
            exit 0
            ;;
         '-d'|'--debug')
            CSL_DEBUG="${CSL_TRUE}"
            shift
            continue
            ;;
         '-v'|'--verbose')
            CSL_VERBOSE="${CSL_TRUE}"
            shift
            continue
            ;;
         '-w'|'--warning')
            _csl_add_threshold WARNING "${2}"
            shift 2
            continue
            ;;
         '-c'|'--critical')
            _csl_add_threshold CRITICAL "${2}"
            shift 2
            continue
            ;;
         '--')
            shift
            break
            ;;
         *)
            if is_empty_str "${1}"; then
               shift
               continue
            fi

            local USER_OPT="${1}" OPT_VAR='' OPT_ARG='' SHIFT=1

            if ! [[ "${USER_OPT}" =~ ^-?-?([[:alnum:]]+)$ ]]; then
               fail "Invalid parameter! ${USER_OPT}"
               show_help
               exit 1
            fi

            USER_OPT="${BASH_REMATCH[1]}"

            if ! is_declared CSL_USER_GETOPT_PARAMS || \
               ! [[ -v "CSL_USER_GETOPT_PARAMS[${USER_OPT}]" ]]; then
               fail "Unknown parameter! ${USER_OPT}"
               show_help
               exit 1
            fi

            OPT_VAR="${CSL_USER_GETOPT_PARAMS[${USER_OPT}]}"

            if ! has_param "${OPT_VAR}"; then
               fail "Unknown parameter! ${OPT_VAR}"
               show_help
               exit 1
            fi

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
            if ! is_declared_func "${OPT_VAR}"; then
               if is_empty_str "${OPT_ARG}"; then
                  CSL_USER_PARAMS_VALUES["${OPT_VAR}"]="${CSL_TRUE}"
               else
                  CSL_USER_PARAMS_VALUES["${OPT_VAR}"]="${OPT_ARG}"
               fi

               shift $SHIFT
               unset -v USER_OPT OPT_VAR OPT_ARG SHIFT
               continue
            fi

            #
            # or if it is handled by a function.
            #
            if ! is_func "${OPT_VAR}"; then
               fail "No valid function '${OPT_VAR}' for parameter '${USER_OPT}'!"
               exit 1
            fi

            ${OPT_VAR} "${OPT_ARG}"
            RETVAL="${?}"

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
   ! is_debug || debug "Debugging: enabled"
   ! is_verbose || verbose "Verbose output: enabled"
   ! is_set CSL_WARNING_THRESHOLD || debug "Warning threshold: ${CSL_WARNING_THRESHOLD[*]}"
   ! is_set CSL_CRITICAL_THRESHOLD || debug "Critical threshold: ${CSL_CRITICAL_THRESHOLD[*]}"
}
readonly -f _csl_parse_parameters

# @function _csl_validate_parameters()
# @brief returns 0, if the given command-line parameters are
# valid. Otherwise it returns 1.
# @return int 0 on success, 1 on failure
_csl_validate_parameters ()
{
   #
   # validate that warning- and critical-thresholds have been correctly provided.
   #
   if ( ( ! is_declared CSL_WARNING_THRESHOLD || is_empty CSL_WARNING_THRESHOLD ) && \
      ( ! is_declared CSL_WARNING_THRESHOLD_DEFAULT || is_empty CSL_WARNING_THRESHOLD_DEFAULT ) ) || \
      ( ( ! is_declared CSL_CRITICAL_THRESHOLD || is_empty CSL_CRITICAL_THRESHOLD ) && \
      ( ! is_declared CSL_CRITICAL_THRESHOLD_DEFAULT || is_empty CSL_CRITICAL_THRESHOLD_DEFAULT ) ); then
      fail "Warning and critical parameters are mandatory!"
      return 1
   fi

   #
   # if no custom thresholds for warning and critical have been set - *but* there are
   # default values for those two present - then take this one's.
   if ( ! is_declared CSL_WARNING_THRESHOLD || is_empty CSL_WARNING_THRESHOLD ) && \
      ( is_declared CSL_WARNING_THRESHOLD_DEFAULT && ! is_empty CSL_WARNING_THRESHOLD_DEFAULT ); then
      debug "using default WARNING threshold"
      _csl_add_threshold WARNING "${CSL_WARNING_THRESHOLD_DEFAULT}"
   fi

    if ( ! is_declared CSL_CRITICAL_THRESHOLD || is_empty CSL_CRITICAL_THRESHOLD ) && \
      ( is_declared CSL_CRITICAL_THRESHOLD_DEFAULT && ! is_empty CSL_CRITICAL_THRESHOLD_DEFAULT ); then
      debug "using default CRITICAL threshold"
      _csl_add_threshold CRITICAL "${CSL_CRITICAL_THRESHOLD_DEFAULT}"
   fi

   #
   # a quick check, that the same count of thresholds are present for warning- as
   # well for critical-thresholds.
   #
   if [ ${#CSL_WARNING_THRESHOLD[@]} -ne ${#CSL_CRITICAL_THRESHOLD[@]} ]; then
      fail "Warning and critical parameters contain different amount of thresholds (w:${#CSL_WARNING_THRESHOLD[@]},c:${#CSL_CRITICAL_THRESHOLD[@]})!"
      return 1
   fi

   local WARN_KEY='' CRIT_KEY=''
   for WARN_KEY in "${!CSL_WARNING_THRESHOLD[@]}"; do
      if ! key_in_array CSL_CRITICAL_THRESHOLD "$(printf '%q' "${WARN_KEY}")"; then
         fail "Warning threshold key '${WARN_KEY}' does not occur in critical thresholds!"
         return 1
      fi
   done

   for CRIT_KEY in "${!CSL_CRITICAL_THRESHOLD[@]}"; do
      if ! key_in_array CSL_WARNING_THRESHOLD "$(printf '%q' "${CRIT_KEY}")"; then
         fail "Critical threshold key '${CRIT_KEY}' does not occur in warning thresholds!"
         return 1
      fi
   done

   local RETVAL=0

   if is_func plugin_params_validate; then
      plugin_params_validate;
      RETVAL="${?}"
   fi

   return $RETVAL
}
readonly -f _csl_validate_parameters


# @function _csl_cleanup()
# @brief is a function, that would be called on soon as this
# script has finished.
# It must be set upped by using setup_cleanup_trap ().
# @param1 int $exit_code
# @return int 0 on success, 1 on failure
_csl_cleanup ()
{
   local EXITCODE="${?}"

   if is_func plugin_cleanup; then
      plugin_cleanup;
   fi

   if ! is_declared CSL_TEMP_DIRS || is_empty CSL_TEMP_DIRS; then
      exit $EXITCODE
   fi

   local CSL_TMPDIR
   for CSL_TMPDIR in "${CSL_TEMP_DIRS[@]}"; do
      ! is_empty_str "${CSL_TMPDIR}" || continue
      is_dir "${CSL_TMPDIR}" || continue
      rm -rf "${CSL_TMPDIR}"
   done

   if is_func plugin_params; then
      plugin_params;
   fi

   exit $EXITCODE
}
readonly -f _csl_cleanup

# @function _csl_has_short_params()
# @brief returns 0, if parameters in short form (-d -w 5...)
# have been given on the command line. Otherwise it returns 1.
# @return int 0 on success, 1 on failure
_csl_has_short_params ()
{
   is_declared CSL_GETOPT_SHORT || return 1
   ! is_empty CSL_GETOPT_SHORT || return 1

   return 0
}
readonly -f _csl_has_short_params

# @function _csl_has_long_params()
# @brief returns 0, if parameters in long form (--debug --warning 5...)
#  have been given on the command line. Otherwise it returns 1.
# @return int 0 on success, 1 on failure
_csl_has_long_params ()
{
   is_declared CSL_GETOPT_LONG || return 1
   ! is_empty CSL_GETOPT_LONG || return 1

   return 0
}
readonly -f _csl_has_long_params

# @function _csl_get_short_params()
# @brief outputs the registered short command-line-parameters
# in the form as required by GNU getopt.
# @output short-params
# @return int 0 on success, 1 on failure
_csl_get_short_params ()
{
   _csl_has_short_params || return 1

   echo "${CSL_GETOPT_SHORT}"
   return 0
}
readonly -f _csl_get_short_params

# @function _csl_get_long_params()
# @brief outputs the registered long command-line-parameters
# in the form as required by GNU getopt.
# @output long-params
# @return int 0 on success, 1 on failure
_csl_get_long_params ()
{
   _csl_has_long_params || return 1

   # remove the trailing comma from the end of the string.
   echo "${CSL_GETOPT_LONG:0:-1}"
   return 0
}
readonly -f _csl_get_long_params

# @function _csl_get_version()
# @brief This function returns this library's version number as defined
# in the $CSL_VERSION. Just in case, it also performs some validation on
# the version number, to ensure not getting fooled.
# @output string version-number
# @return int 0 on success, 1 on failure
_csl_get_version ()
{
   [[ -v CSL_VERSION ]] || return 1
   ! is_empty CSL_VERSION || return 1
   [[ "${CSL_VERSION}" =~ ^[[:digit:]]+(\.[[:digit:]]+)*$ ]] || return 1

   echo "${CSL_VERSION}"
   return 0
}
readonly -f _csl_get_version

# @function _csl_add_threshold()
# @brief With this function, warning- and critical-thresholds for certain
# 'keys' are registered. A key is the text the matches a given input
# value.
# @param1 string Either 'WARNING' or 'CRITICAL'
# @param2 string key name
# @return int
_csl_add_threshold ()
{
   if [ $# -ne 2 ] || \
      is_empty_str "${1}" || \
      is_empty_str "${2}" || \
      ! [[ "${1}" =~ ^(WARNING|CRITICAL)$ ]]; then
      fail "Invalid parameters"
      return 1
   fi

   local -n TARGET="CSL_${1}_THRESHOLD"
   local THRESHOLD="${2}"
   local -a THRESHOLD_ARY=()
   local KEY='' VAL='' KEY_CNT=0

   IFS=',' read -r -a THRESHOLD_ARY <<< "${THRESHOLD}"

   if ! is_array THRESHOLD_ARY || [ ${#THRESHOLD_ARY[@]} -lt 1 ]; then
      fail "Invalid ${1} threshold! Check the syntax."
      exit 1
   fi

   for THRESHOLD_COUPLE in "${THRESHOLD_ARY[@]}"; do
      ! is_empty_str "${THRESHOLD_COUPLE}" || continue

      if ! [[ "${THRESHOLD_COUPLE}" =~ ^([[:graph:]]+)=([[:graph:]]+)$ ]]; then
         #echo "SINGLE>>> ${THRESHOLD_COUPLE}"
         if ! is_valid_threshold "${THRESHOLD_COUPLE}"; then
            fail "${1} parameter contains an invalid threshold! Check the syntax."
            exit 1
         fi

         debug "adding ${1} threshold: ${THRESHOLD_COUPLE}"

         # as we use an associative array in CSL_(WARNING|CRITICAL)_THRESHOLD, construct
         # an array key to be able to push the value to the array.
         TARGET+=( ["key${KEY_CNT}"]="${THRESHOLD_COUPLE}" )
         ((KEY_CNT+=1))
         continue
      fi

      [ ${#BASH_REMATCH[@]} -eq 3 ] || continue

      #IFS='=' read -r KEY VAL <<< "${THRESHOLD_COUPLE}"
      KEY="${BASH_REMATCH[1]}"
      VAL="${BASH_REMATCH[2]}"

      ! is_empty_str "${KEY}" || continue
      ! is_empty_str "${VAL}" || continue

      if ! is_valid_threshold "${VAL}"; then
         fail "${1} parameter contains an invalid threshold! Check the syntax."
         exit 1
      fi

      debug "adding ${1} threshold: ${KEY}=${VAL}"

      #echo "COUPLE>>> a ${KEY} ${VAL}"
      TARGET+=( ["${KEY}"]="${VAL}" )
   done

   # enable for debugging, as this code runs before CSL_DEBUG=true has been set
   # by _csl_parse_parameters() which would then enable debug output.
   #for KEY in "${!TARGET[@]}"; do
      #echo "Threshold ${1}: ${KEY}=${TARGET["${KEY}"]}"
   #done
}
readonly -f _csl_add_threshold

# @function _csl_add_limit()
# @todo to be removed by 2017-12-31
# @deprecated true
_csl_add_limit ()
{
   _csl_deprecate_func _csl_add_threshold "${@}"
}
readonly -f _csl_add_limit

# @function _csl_compare_version()
# @brief This function compares to version strings.
# Credits to original author Dennis Williamson @ stackoverflow (see link).
# @param1 string version1
# @param2 string version2
# @output string eq = equal,lt = less than,gt = greater than
# @return 0 on success, 1 on failure
# @link https://stackoverflow.com/a/4025065
_csl_compare_version ()
{
   if ! [ "${#}" -eq 2 ] || \
      is_empty_str "${1}" || \
      is_empty_str "${2}"; then
      fail "Invalid parameters"
      return 1
   fi

   if ! [[ "${1}" =~ ^[[:digit:]]+(\.[[:digit:]]+)*$ ]]; then
      fail "Parameter 1 does not look like a version number!"
      return 1
   fi

   if ! [[ "${2}" =~ ^[[:digit:]]+(\.[[:digit:]]+)*$ ]]; then
      fail "Parameter 2 does not look like a version number!"
      return 1
   fi

   if [[ "${1}" == "${2}" ]]; then
      echo "eq"
      return 0
   fi

   local IFS=.
   local i ver1=($1) ver2=($2)
   # fill empty fields in ver1 with zeros
   for ((i=${#ver1[@]}; i<${#ver2[@]}; i++)); do
      ver1[i]=0
   done

   for ((i=0; i<${#ver1[@]}; i++)); do
      if ! [[ -v "ver2[${i}]" ]] || [[ -z ${ver2[i]} ]]; then
         # fill empty fields in ver2 with zeros
         ver2[i]=0
      fi

      if ((10#${ver1[i]} > 10#${ver2[i]})); then
         echo "gt"
         return 0
      fi

      if ((10#${ver1[i]} < 10#${ver2[i]})); then
         echo "lt"
         return 0
      fi
   done

   echo "eq"
   return 0
}
readonly -f _csl_compare_version

# @function _csl_require_libvers()
# @brief This function checks if the current library version number
# is matching the requiremented version as specified in $1.
# @output string lt (less-than), eq (equal), gt (greater-than)
# @return int 0 on success, 1 on failure
_csl_require_libvers ()
{
   if ! [ $# -eq 1 ] || \
      is_empty_str "${1}" || \
      ! [[ "${1}" =~ ^[[:digit:]]+(\.[[:digit:]]+)*$ ]]; then
      fail "Invalid parameters"
      return 1
   fi

   local REQ_LIB_VERS="${1}" CUR_LIB_VERS RESULT RETVAL

   CUR_LIB_VERS="$(_csl_get_version)"
   [ ! -z "${CUR_LIB_VERS}" ] || return 1

   RESULT="$(_csl_compare_version "${CUR_LIB_VERS}" "${REQ_LIB_VERS}")"
   RETVAL="${?}"

   [ "x${RETVAL}" == "x0" ] || return 1
   [[ "${RESULT}" =~ ^(lt|eq|gt)$ ]] || return 1

   echo "${RESULT}"
   return "${RETVAL}"
}
readonly -f _csl_require_libvers

# @function _csl_deprecate_func()
# @brief This function can be used to output a message when a
# deprecated function has been called. It issues the message,
# then invokes the replacement function given in $1 with all
# the further parameters the deprecated function was called with.
# @param1 string replacement-function
# @return int the replacement-functions exit-code
function _csl_deprecate_func ()
{
   if [ $# -lt 2 ]; then
      fail "Invalid parameters"
      return 1
   fi

   local OLD_FUNC="${FUNCNAME[1]}"
   local NEW_FUNC="${1}"; shift

   echo "${OLD_FUNC}() is deprecated, use ${NEW_FUNC}() instead."
   ${NEW_FUNC} "${@}"
}
readonly -f _csl_deprecate_func

#
# </Functions>
#


###############################################################################
