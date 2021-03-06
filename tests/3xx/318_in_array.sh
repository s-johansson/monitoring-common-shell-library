#!/bin/bash

. common.sh

assert_func in_array "${TEST_FAIL}" "Invalid[[:blank:]]parameters"
assert_func in_array "${TEST_FAIL}" "Invalid[[:blank:]]parameters" bla
assert_func in_array "${TEST_FAIL}" "Invalid[[:blank:]]parameters" bla bla bla
assert_func in_array "${TEST_FAIL}" "Invalid[[:blank:]]parameters" ^bla$ ^bla$
declare -a -g TEST_ARY=()
assert_func in_array "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY bla
assert_func in_array "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY ^bla$
TEST_ARY+=( 'bla' )
assert_func in_array "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY bla
assert_func in_array "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY ^bla$
unset -v TEST_ARY
