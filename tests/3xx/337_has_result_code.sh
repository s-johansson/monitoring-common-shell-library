#!/bin/bash

. common.sh

assert_func has_result_code $TEST_FAIL $TEST_EMPTY
CSL_RESULT_CODE="FOOBAR"
assert_func has_result_code $TEST_FAIL $TEST_EMPTY
CSL_RESULT_CODE="1"
assert_func has_result_code $TEST_OK $TEST_EMPTY
unset -v CSL_RESULT_CODE
