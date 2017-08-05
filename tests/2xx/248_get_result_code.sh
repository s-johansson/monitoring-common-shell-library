#!/bin/bash

. common.sh

assert_func get_result_code $TEST_FAIL $TEST_EMPTY
CSL_RESULT_CODE="FOOBAR"
assert_func get_result_code $TEST_FAIL $TEST_EMPTY
CSL_RESULT_CODE="1"
assert_func get_result_code $TEST_OK "1"
unset -v CSL_RESULT_CODE
