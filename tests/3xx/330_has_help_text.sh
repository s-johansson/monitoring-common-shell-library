#!/bin/bash

. common.sh

assert_func has_help_text $TEST_FAIL $TEST_EMPTY
CSL_HELP_TEXT="bla"
assert_func has_help_text $TEST_OK $TEST_EMPTY
unset -v CSL_HELP_TEXT
