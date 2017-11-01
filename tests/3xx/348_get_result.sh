#!/bin/bash

. common.sh

assert_func get_result "${TEST_FAIL}" "Invalid[[:blank:]]parameters"
assert_func get_result "${TEST_FAIL}" "Invalid[[:blank:]]parameters" foo bar
assert_func get_result "${TEST_FAIL}" "Invalid[[:blank:]]parameters" 'fo o'
assert_func get_result "${TEST_FAIL}" "Invalid[[:blank:]]parameters" 'fo o' bar

CSL_RESULT_VALUES=()
assert_func get_result "${TEST_FAIL}" "${TEST_EMPTY}" foo
CSL_RESULT_VALUES+=( ['abc']='123' )
assert_func get_result "${TEST_FAIL}" "${TEST_EMPTY}" foo
assert_func get_result "${TEST_OK}" "123" abc
CSL_RESULT_VALUES=()
assert_func get_result "${TEST_FAIL}" "${TEST_EMPTY}" abc
unset -v CSL_RESULT_VALUES
