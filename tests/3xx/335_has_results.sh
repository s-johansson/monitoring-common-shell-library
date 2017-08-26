#!/bin/bash

. common.sh

assert_func has_results "${TEST_FAIL}" "${TEST_EMPTY}"
CSL_RESULT_VALUES=()
assert_func has_results "${TEST_FAIL}" "${TEST_EMPTY}"
CSL_RESULT_VALUES+=( ['abc']='123' )
assert_func has_results "${TEST_OK}" "${TEST_EMPTY}"
unset -v CSL_RESULT_VALUES
