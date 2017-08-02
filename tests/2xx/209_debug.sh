#!/bin/bash

. common.sh

DEBUG=1
RESULT=$(debug "bla" 2>&1)
assert_equals "${RESULT}" "^main\(\[$(((LINENO-1)))\]\):[[:blank:]]+bla$"
unset -v DEBUG RESULT
