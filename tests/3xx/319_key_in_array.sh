#!/bin/bash

. common.sh

assert_func key_in_array "${TEST_FAIL}" "Invalid[[:blank:]]parameters"
assert_func key_in_array "${TEST_FAIL}" "Invalid[[:blank:]]parameters" foo
assert_func key_in_array "${TEST_FAIL}" "Invalid[[:blank:]]parameters" foo bar bla

assert_func key_in_array "${TEST_FAIL}" "Invalid[[:blank:]]parameters" foo bar

declare -A -g TEST_ARY=()

assert_func key_in_array "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY foo
assert_func key_in_array "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY ^foo$
assert_func key_in_array "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY ^$

TEST_ARY=(
   ['abc']='123'
   ['dE*']='456'
   ['ghi']='789'
)

assert_func key_in_array "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY abc
assert_func key_in_array "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY '^abc'
assert_func key_in_array "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY '^abc$'
assert_func key_in_array "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY xabc
assert_func key_in_array "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY abcx
assert_func key_in_array "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY Abc

assert_func key_in_array "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY 'dE*'
assert_func key_in_array "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY '^de?'
assert_func key_in_array "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY '^dE.?$'

unset -v TEST_ARY
