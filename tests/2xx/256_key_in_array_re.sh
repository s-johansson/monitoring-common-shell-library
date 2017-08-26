#!/bin/bash

. common.sh

assert_func key_in_array_re "${TEST_FAIL}" "Invalid[[:blank:]]parameters"
assert_func key_in_array_re "${TEST_FAIL}" "Invalid[[:blank:]]parameters" foo
assert_func key_in_array_re "${TEST_FAIL}" "Invalid[[:blank:]]parameters" foo bar bla

unset -v foo
assert_func key_in_array_re "${TEST_FAIL}" "Invalid[[:blank:]]parameters" foo bar

declare -A -g TEST_ARY=()

assert_func key_in_array_re "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY foo
assert_func key_in_array_re "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY ^foo$
assert_func key_in_array_re "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY ^$

TEST_ARY=(
   ['abc']='123'
   ['^def$']='456'
   ['^[[:punct:]]+$']='789'
)

assert_func key_in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY abc
assert_func key_in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY '^abc'
assert_func key_in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY '^abc$'
assert_func key_in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY xabc
assert_func key_in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY abcx
assert_func key_in_array_re "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY Abc
assert_func key_in_array_re "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY axbc
assert_func key_in_array_re "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY Axbc
assert_func key_in_array_re "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY A_bc

assert_func key_in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY 'def'
assert_func key_in_array_re "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY 'def*'
assert_func key_in_array_re "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY 'xdef'
assert_func key_in_array_re "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY 'xde?'
assert_func key_in_array_re "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY 'defx'
assert_func key_in_array_re "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY '^dE.?$'

assert_func key_in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY '...'
assert_func key_in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY '.+.'
assert_func key_in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY '_+_'
assert_func key_in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY '_*\+'
assert_func key_in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY '^_*+'
assert_func key_in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY '^_*+$'
assert_func key_in_array_re "${TEST_OK}" "${TEST_EMPTY}" TEST_ARY '^_"+$'
assert_func key_in_array_re "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY '3_*+'
assert_func key_in_array_re "${TEST_FAIL}" "${TEST_EMPTY}" TEST_ARY '_*+3'

unset -v TEST_ARY
