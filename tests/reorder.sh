#!/bin/bash

# This script reorders the testfiles that reside in the [[:digit:]]xx directories
# and moves them to their position as defined in test_seq.dat.

###############################################################################

# This file is part of the monitoring-common-shell-library.
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

###############################################################################

set -u -e -o pipefail  # exit-on-error, error on undeclared variables.

in_array ()
{
   if [ $# -ne 2 ] || \
      ! [[ "${1}" =~ ^[[:graph:]]+$ ]]; then
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

is_cmd ()
{
   [ $# -eq 1 ] || return 1
   ! [ -z "${1}" ] || return 1

   command -v "${1}" >/dev/null 2>&1;
   return $?
}

cleanup ()
{
   local RETVAL=${?}
   popd >/dev/null
   exit "${RETVAL}"
}

trap cleanup INT QUIT TERM EXIT

is_cmd find || { echo "Missing 'find'!"; exit 1; }
is_cmd realpath || { echo "Missing 'realpath'!"; exit 1; }

readonly CURDIR="$(dirname "$(realpath "${BASH_SOURCE[@]}")")"
readonly TESTSEQ_DAT="${CURDIR}/test_seq.dat"
readonly FUNCTIONS_SH="${CURDIR}/../functions.sh"

[ -e "${TESTSEQ_DAT}" ] || { echo "${TESTSEQ_DAT} does not exist!"; exit 1; }
[ -e "${FUNCTIONS_SH}" ] || { echo "${FUNCTIONS_SH} does not exist!"; exit 1; }

declare -a FUNC_LIST=()
declare -a GROUP_LIST=()

while read -r line; do
   # skip empty lines
   [ ! -z "${line}" ] || continue
   # proceed on line that look like function declarations
   [[ "${line}" =~ ^([a-z0-9_]+)[[:blank:]]*\(\)[[:blank:]]*$ ]] || continue
   [ "${#BASH_REMATCH[@]}" -eq 2 ] || continue
   
   # record the function
   FUNC_LIST+=( "${BASH_REMATCH[1]}" )

   # check if the function already appears in $TESTSEQ_DAT
   if ! grep -qsE "^${BASH_REMATCH[1]}$" ${TESTSEQ_DAT}; then
      echo
      echo "Function '${BASH_REMATCH[1]}' is not listed in ${TESTSEQ_DAT}."
      echo "Please add it on your own at the right position."
      echo
      exit 1
   fi
done < "${FUNCTIONS_SH}"

echo "Found ${#FUNC_LIST[@]} functions in ${FUNCTIONS_SH}."

pushd "${CURDIR}" >/dev/null
GROUP="" IN_GROUP_CNT=0 LINE_CNT=0 TEST_CNT=0
while read -r line; do
   ((LINE_CNT+=1))
   # skip empty lines
   [ ! -z "${line}" ] || continue
   # skip comment lines
   ! [[ "${line}" =~ ^(#[[:print:]]*|[[:blank:]]*)$ ]] || continue

   # handle group-sections
   if [[ "${line}" =~ ^\[([[:digit:]])xx\][[:blank:]]*$ ]]; then
      GROUP="${BASH_REMATCH[1]}xx"
      # reset the test-counter
      IN_GROUP_CNT="${BASH_REMATCH[1]}00"
      GROUP_LIST+=( "${GROUP}" )
      continue
   fi

   # skip lines as long as we have not entered a group
   [ ! -z "${GROUP}" ] || continue
   FUNCTION_NAME="${line,,}"
   ((TEST_CNT+=1))

   # check that testfiles from 2xx and 3xx have a match in FUNC_LIST[]
   if ! in_array FUNC_LIST "^${FUNCTION_NAME}$" && \
      [[ "${GROUP}" =~ ^(2|3)xx$ ]]; then
      echo "Have a testfile for '${FUNCTION_NAME}', but it is not in ${FUNCTIONS_SH}!"
      exit 1
   fi

   # if the file is already at the correct position, move on.
   if [ -e "${GROUP}/${IN_GROUP_CNT}_${FUNCTION_NAME}.sh" ]; then
      ((IN_GROUP_CNT+=1))
      continue
   fi

   # check if we find the file anywhere else
   #ALT_POS="$(/usr/bin/find -D search *xx -iregex "[[:digit:]]+_${FUNCTION_NAME}.sh$" -regextype posix-egrep)"
   #ALT_POS="$(/usr/bin/find *xx -iregex ".*/([[:digit:]]+)_${FUNCTION_NAME}\.sh$" -regextype posix-extended)"
   ALT_POS="$(/usr/bin/find ./*xx -iregex ".*/[0-9][0-9][0-9]_${FUNCTION_NAME}\.sh" -regextype posix-extended)"
   RETVAL=$?

   if [ "x${RETVAL}" != "x0" ]; then
      echo "find exited non-zero!"
      exit 1
   fi

   if [ -z "${ALT_POS}" ]; then
      echo "Unable to locate the testfile for '${FUNCTION_NAME}()'!"
      exit 1
   fi

   NEW_POS="${GROUP}/${IN_GROUP_CNT}_${FUNCTION_NAME}.sh"

   if [ -e "${NEW_POS}" ]; then
      echo "Quirks! It looks like there are multiple testfiles for '${FUNCTION_NAME}'."
      ls -l "${ALT_POS}"
      ls -l "${NEW_POS}"
      exit 1
   fi

   echo "Updating location of testfile for '${FUNCTION_NAME}'"
   echo "CUR: ${ALT_POS}"
   echo "NEW: ${NEW_POS}"

   [ -d "${GROUP}" ] || mkdir "${GROUP}"
   mv -v -n "${ALT_POS}" "${NEW_POS}"
   RETVAL=$?

   if [ "x${RETVAL}" != "x0" ]; then
      echo "FAILED: move exited non-zero (${RETVAL})!"
      exit 1
   fi

   echo "OK"
   echo

   ((IN_GROUP_CNT+=1))
done < "${TESTSEQ_DAT}"

echo "Parsed ${LINE_CNT} lines in ${TESTSEQ_DAT}."
echo "There are ${TEST_CNT} testfiles in directories ${GROUP_LIST[*]}"
