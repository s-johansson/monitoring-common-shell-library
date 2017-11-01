#!/bin/bash

. common.sh

assert_func _csl_add_threshold "${TEST_FAIL}" "Invalid[[:blank:]]parameters"
assert_func _csl_add_threshold "${TEST_FAIL}" "Invalid[[:blank:]]parameters" foo
assert_func _csl_add_threshold "${TEST_FAIL}" "Invalid[[:blank:]]parameters" foo bar
assert_func _csl_add_threshold "${TEST_FAIL}" "Invalid[[:blank:]]parameters" foo bar bla
assert_func _csl_add_threshold "${TEST_FAIL}" "Invalid[[:blank:]]parameters" Warning foo
assert_func _csl_add_threshold "${TEST_FAIL}" "Invalid[[:blank:]]parameters" Critical foo
assert_func _csl_add_threshold "${TEST_FAIL}" "parameter[[:blank:]]contains[[:blank:]]an[[:blank:]]invalid" WARNING val1=5:val2=,2:
assert_func _csl_add_threshold "${TEST_FAIL}" "parameter[[:blank:]]contains[[:blank:]]an[[:blank:]]invalid" WARNING 'foo ba'
assert_func _csl_add_threshold "${TEST_FAIL}" "parameter[[:blank:]]contains[[:blank:]]an[[:blank:]]invalid" WARNING 'foo_ba'

assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING 5
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING -5
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING 5:
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING -5:
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING :5
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING :-5
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING 5:10
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING -5:10
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING 10:5
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING 10:-5
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING 10:5,
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING -10:5,
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING 5,2
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING 5,-2
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING 5:,2:
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING :5,:2
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING 5:10,2:7
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING 10:5,7:2
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING 10:5,-7:2
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING 10:5,7:2,
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING 10:5,7:-2,
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING 10:5,7:-2,foo

assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING val1=5
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING val1=5:
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING val1=:5
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING val1=5:10
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING val1=10:5
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING val1=10:5,

assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING val1=5,2
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING val1=5:,2:
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING val1=:5,:2
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING val1=5:10,2:7
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING val1=10:5,7:2
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING val1=10:5,7:2,
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING val1=5,val2=2
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING val1=5:,val2=2:
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING val1=:5,val2=:2
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING val1=5:10,val2=2:7
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING val1=10:5,val2=7:2
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING val1=10:5,val2=7:2,

assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" WARNING 555x
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" CRITICAL foo
assert_func _csl_add_threshold "${TEST_OK}" "${TEST_EMPTY}" CRITICAL 555x
