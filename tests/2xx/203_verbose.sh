#!/bin/bash

. common.sh

CSL_VERBOSE=true
RESULT=$(verbose "bla" 2>&1)
assert_equals "${RESULT}" "^main\(\[$(((LINENO-1)))\]\):[[:blank:]]+bla$"
CSL_VERBOSE=false
unset -v RESULT
