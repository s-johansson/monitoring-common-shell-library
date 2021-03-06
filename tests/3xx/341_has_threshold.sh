#!/bin/bash

. common.sh

assert_func has_threshold "${TEST_FAIL}" "Invalid[[:blank:]]parameters"
assert_func has_threshold "${TEST_FAIL}" "Invalid[[:blank:]]parameters" foo bar
assert_func has_threshold "${TEST_FAIL}" "Invalid[[:blank:]]parameters" 'fo o'
assert_func has_threshold "${TEST_FAIL}" "Invalid[[:blank:]]parameters" 'fo o' bar

CSL_WARNING_THRESHOLD=()
assert_func has_threshold "${TEST_FAIL}" "${TEST_EMPTY}" foo
CSL_WARNING_THRESHOLD+=( ['abc']='123' )
assert_func has_threshold "${TEST_FAIL}" "${TEST_EMPTY}" foo
assert_func has_threshold "${TEST_OK}" "${TEST_EMPTY}" abc
CSL_WARNING_THRESHOLD=()
assert_func has_threshold "${TEST_FAIL}" "${TEST_EMPTY}" abc
unset -v CSL_WARNING_THRESHOLD
