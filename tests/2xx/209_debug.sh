#!/bin/bash

. common.sh

CSL_DEBUG=1
RESULT=$(debug "bla" 2>&1)
assert_equals "${RESULT}" "^main\(\[$(((LINENO-1)))\]\):[[:blank:]]+bla$"
unset -v CSL_DEBUG RESULT
