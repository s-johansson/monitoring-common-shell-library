#!/bin/bash

#headerdoc2html -p ../functions.sh -X -o $(pwd)
#headerdoc2html -p ../functions.sh -o $(pwd) -C -b
#pandoc -f docbook -t markdown -o functions.md functions_sh/functions.sh.xml
#pandoc -f docbook -t plain -o functions.md functions_sh/functions.sh.xml
#pandoc -f html -t markdown -o functions.md functions_sh/index.html

shopt -s extglob

if [ $# -eq 1 ] && [ "${1}" == "-d" ]; then
   DEBUG=true
fi

INPUT='functions.sh'
OUTPUT="FUNCREF.md"

# helper variables
declare -g -a SRC_FILE=()
declare -g -a ALLOWED_TAGS=(
   'function'
   'param[[:digit:]]'
   'brief'
   'output'
   'return'
)
declare -A STANZA=()

# found at https://raymii.org/s/snippets/Bash_Bits_Check_If_Item_Is_In_Array.html
in_array () {
   local -a 'haystack=("${'"$1"'[@]}")'
   for i in "${haystack[@]}"; do
      if [[ "${2}" =~ ${i} ]]; then
         return 0
      fi
   done
   return 1
}

is_allowed_tag ()
{
   [ $# -eq 1 ] || return 1
   [ ! -z "${1}" ] || return 1
   in_array ALLOWED_TAGS "${1}" || return 1

   return 0
}

is_debug ()
{
   [[ -v DEBUG ]] || return 1;
   [ ! -z "${DEBUG}" ] || return 1;
   [ "x${DEBUG}" != "x0" ] || return 1;

   return 0
}

debug ()
{
   is_debug || return 0;

   echo -e "${FUNCNAME[1]}([${BASH_LINENO[0]}]):\t${1}" >&2
}

write ()
{
   [ $# -eq 1 ] || return 0
   echo "${1}" >>${OUTPUT}
}

read_file  ()
{
   [ $# -eq 1 ] || return 1
   [ -r "${1}" ] || return 1

   #read -r -a SRC_FILE < ${1}
   mapfile -t SRC_FILE < ${1}
}

parse_input ()
{
   local IN_STANZA=false IN_MULTILINE=false
   local CUR_TAG= CUR_VAL=

   for LINE in "${SRC_FILE[@]}"; do
      #echo "LINE: ${LINE}"

      # if we are in a stanza, and the next line looks like '^$FUNCNAME ()$',
      # we assume we have reached the end of the stanza.
      if ${IN_STANZA} && [[ -v STANZA['function'] ]] && [[ "${LINE}" =~ ^${STANZA['function']}[[:blank:]]*\(\)[[:blank:]]* ]]; then
         if is_debug; then
            debug "End of stanza found. Clearing."
            for KEY in ${!STANZA[@]}; do
               debug "${KEY}: ${STANZA[$KEY]}"
               continue
            done
            echo; echo; echo
         fi

         formated_output STANZA


         IN_STANZA=false IN_MULTILINE=false CUR_TAG= CUR_VAL=
         continue
      fi

      # if we are currently already parsing a stanza, and there is now another
      # @function line, something must be wrong.
      if ${IN_STANZA} && [[ "${LINE}" =~ ^#[[:blank:]]*@function:?[[:blank:]]+([[:graph:]]+)\(\)[[:blank:]]*$ ]]; then
         echo "Already parsing stanza for function '${STANZA['function']}()', but now encountering another function line":
         echo ">>> ${LINE}"
         echo "Please check if the @function tag value does not match the followed function() name ${STANZA['function']}."
         exit 1
      fi

      if ! ${IN_STANZA}; then
         # continue to the next line, if we are not currently already parsing
         # an doc-stanza _and_ the current line does not look like another tag
         # line in the format '@function abc()'
         if ! [[ "${LINE}" =~ ^#[[:blank:]]*@function:?[[:blank:]]+([[:graph:]]+)\(\)[[:blank:]]*$ ]]; then
            debug "SKIPPING: ${LINE}"
            continue
         fi

         debug "Found new stanza for function: ${STANZA['function']}()"
         [ ! -z "${BASH_REMATCH[1]}" ] || continue

         STANZA=()
         STANZA['function']="${BASH_REMATCH[1]}"
         IN_STANZA=true CUR_TAG= CUR_VAL=
         ! is_debug && echo "Parsing ${STANZA['function']}() tags..."
         continue
      fi

      if ! ${IN_MULTILINE} && ! [[ "${LINE}" =~ ^#[[:blank:]]*@([[:alnum:]]+):?[[:blank:]]+([[:print:]]+)$ ]]; then
         continue
      fi

      if ! ${IN_MULTILINE} && [ ${#BASH_REMATCH[@]} -eq 3 ]; then
         CUR_TAG="${BASH_REMATCH[1]}"
         CUR_VAL="${BASH_REMATCH[2]}"

         if ! is_allowed_tag "${CUR_TAG}"; then
            echo "Disallowed tag found: ${CUR_TAG}"
            exit 1
         fi
      fi

      if ${IN_MULTILINE}; then
         if [[ "${LINE}" =~ ^#[[:blank:]]*@[[:alnum:]]+:?[[:blank:]]* ]]; then
            echo "Already parsing a multiline tag '${CUR_TAG}' in function '${STANZA['function']}()', but now already encountering another tag line":
            echo ">>> ${LINE}"
            echo "Please check if you have a trailing backslash on the last line of the multiline tag!"
            exit 1
         fi

         if ! [[ "${LINE}" =~ ^#[[:blank:]]([[:print:]]+)$ ]]; then
            echo "Encountered an unusual multiline. Please check."
            exit 1
         fi

         CUR_VAL="${BASH_REMATCH[1]%+([[:blank:]])\\*([[:blank:]])}"
         STANZA[${CUR_TAG}]+=" ${CUR_VAL}"

         if ! [[ "${BASH_REMATCH[1]}" =~ [[:blank:]]\[[:blank:]]*$ ]]; then
            IN_MULTILINE=false
            CUR_TAG=
            CUR_VAL=
         fi
         continue
      fi

      if [[ "${LINE}" =~ ([[:blank:]]\\[[:blank:]]*)$ ]]; then
         IN_MULTILINE=true
         # strip the \ from the end
         CUR_VAL="${CUR_VAL%+([[:blank:]])\\*([[:blank:]])}"
      fi

      debug "Tag found: ${CUR_TAG}, value: ${CUR_VAL}"

      # tags with empty values we do not need to record.
      [ ! -z "${CUR_VAL}" ] || continue
      STANZA[${CUR_TAG}]="${CUR_VAL}"
   done
}

formated_output ()
{
   [ $# -eq 1 ] || return 1
   local -n FUNC_STANZA=$1
   local TMPSTR=

   if ! [[ -v FUNC_STANZA['function'] ]]; then
      return 0
   fi

   write "## \`${FUNC_STANZA['function']}\`";
   write ""

   [[ -v FUNC_STANZA['brief'] ]] && { write "${FUNC_STANZA['brief']}"; write ""; }

   if [[ -v FUNC_STANZA['param1'] ]]; then
      write "***Parameters***"; write ""
      for PARAID in $(seq -s ' ' 1 10); do
         [[ -v FUNC_STANZA["param${PARAID}"] ]] && write "*Parameter ${PARAID}*: ${FUNC_STANZA["param${PARAID}"]}"
      done
      write ""
   fi
   [[ -v FUNC_STANZA['output'] ]] && { write "*Outputs*: ${FUNC_STANZA['output']}"; write ""; }
   if [[ -v FUNC_STANZA['return'] ]]; then

      if [[ "${FUNC_STANZA['return']}" =~ ^([[:alnum:]]+)[[:blank:]]*([[:print:]]*)$ ]]; then
         write "***Returns***"; write ""
         write "Type: \`${BASH_REMATCH[1]}\`"
         if [[ -v BASH_REMATCH[2] ]] && [ ! -z "${BASH_REMATCH[2]}" ]; then
            write "${BASH_REMATCH[2]}"
         fi
         write ""
      fi
   fi
   [[ -v FUNC_STANZA['example'] ]] && { write "\`\`\`"; write "${FUNC_STANZA['example']}";  write "\`\`\`"; }
   write ""
}

read_file ${INPUT}
echo -n >${OUTPUT}
write "# Function Reference"
parse_input

