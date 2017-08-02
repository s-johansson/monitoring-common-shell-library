#!/bin/bash

. common.sh

RESULT=$(fail "bla" 2>&1)
assert_equals "${RESULT}" "^main\(\[$(((LINENO-1)))\]\):[[:blank:]]+bla$"
unset -v RESULT
