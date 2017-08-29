#!/bin/bash

. common.sh

assert_func get_threshold_for_key "${TEST_FAIL}" "Invalid[[:blank:]]parameters"
assert_func get_threshold_for_key "${TEST_FAIL}" "Invalid[[:blank:]]parameters" foo
assert_func get_threshold_for_key "${TEST_FAIL}" "Invalid[[:blank:]]parameters" foo bar
assert_func get_threshold_for_key "${TEST_FAIL}" "Invalid[[:blank:]]parameters" foo bar bla
assert_func get_threshold_for_key "${TEST_FAIL}" "Invalid[[:blank:]]parameters" WARNING foo bar
assert_func get_threshold_for_key "${TEST_FAIL}" "Invalid[[:blank:]]parameters" WARNING 'fo o'
assert_func get_threshold_for_key "${TEST_FAIL}" "Invalid[[:blank:]]parameters" WARNING 'fo o' bar

assert_func get_threshold_for_key "${TEST_FAIL}" "${TEST_EMPTY}" WARNING foo
declare -g CSL_WARNING_THRESHOLD=()
assert_func get_threshold_for_key "${TEST_FAIL}" "${TEST_EMPTY}" WARNING foo
CSL_WARNING_THRESHOLD=(
   ['foo']='bar'
)
assert_func get_threshold_for_key "${TEST_OK}" "bar" WARNING foo
assert_func get_threshold_for_key "${TEST_FAIL}" "${TEST_EMPTY}" WARNING bar
CSL_WARNING_THRESHOLD=()
assert_func get_threshold_for_key "${TEST_FAIL}" "${TEST_EMPTY}" WARNING foo
