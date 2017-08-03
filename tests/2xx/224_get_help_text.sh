#!/bin/bash

. common.sh

#set -x
assert_func get_help_text $TEST_FAIL $TEST_EMPTY
CSL_HELP_TEXT='bla'
assert_func get_help_text $TEST_OK 'bla'
unset -v CSL_HELP_TEXT
