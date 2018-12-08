#!/bin/bash

. common.sh

CSL_DEBUG=true
RESULT=$(debug "bla" 2>&1)
assert_equals "${RESULT}" "^main\(\[$(((LINENO-1)))\]\):[[:blank:]]+bla$"
CSL_DEBUG=false
unset -v RESULT
