#!/bin/bash

. common.sh

assert_func has_result_text $TEST_FAIL $TEST_EMPTY
CSL_RESULT_TEXT="FOOBAR"
assert_func has_result_text $TEST_OK $TEST_EMPTY
unset -v CSL_RESULT_TEXT
