#!/bin/bash

. common.sh

assert_func get_result_text $TEST_FAIL $TEST_EMPTY
CSL_RESULT_TEXT="FOOBAR"
assert_func get_result_text $TEST_OK "FOOBAR"
unset -v CSL_RESULT_TEXT
