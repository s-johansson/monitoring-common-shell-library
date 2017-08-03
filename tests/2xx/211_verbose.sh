#!/bin/bash

. common.sh

CSL_VERBOSE=1
RESULT=$(verbose "bla" 2>&1)
assert_equals "${RESULT}" "^main\(\[$(((LINENO-1)))\]\):[[:blank:]]+bla$"
unset -v CSL_VERBOSE RESULT
