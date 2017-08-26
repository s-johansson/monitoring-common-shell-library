#!/bin/bash

. common.sh

# shellscript disable=SC2034
declare -g -a TEST_ARY

assert_func in_array_re "${TEST_FAIL}" "Invalid[[:blank:]]parameters"
assert_func in_array_re "${TEST_FAIL}" "Invalid[[:blank:]]parameters" foo
assert_func in_array_re "${TEST_FAIL}" "Invalid[[:blank:]]parameters" foo bar bla

declare -a -g TEST_ARY=()
assert_func in_array_re "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY bla
assert_func in_array_re "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY ^bla$

TEST_ARY+=( '^bla$' )
declare -g -a TEST_ARY=(
   'abc'
   '^def'
   'ghi$'
   '^[[:punct:]]+$'
)

assert_func in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY abc
assert_func in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY abcd
assert_func in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY xabc
assert_func in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY xabcd
assert_func in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY "^abc$"

assert_func in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY def
assert_func in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY defg
assert_func in_array_re "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY xdef

assert_func in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY ghi
assert_func in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY xghi
assert_func in_array_re "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY ghiy

assert_func in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY '_:='
assert_func in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY '^_:=$'
assert_func in_array_re "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY '1_:='
assert_func in_array_re "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY '1_:=2'
assert_func in_array_re "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY '1xx=2'

unset -v TEST_ARY
