#!/bin/bash

. common.sh

assert_func is_empty "${TEST_FAIL}" "${TEST_EMPTY}"
assert_func is_empty "${TEST_FAIL}" "${TEST_EMPTY}" '/tmp' 'bla'

assert_func is_empty "${TEST_FAIL}" "${TEST_EMPTY}" ''
assert_func is_empty "${TEST_FAIL}" "${TEST_EMPTY}" 'foo'

declare -g -a TESTARY=()
assert_func is_empty "${TEST_OK}" "${TEST_EMPTY}" TESTARY
TESTARY+=( 'foo' )
assert_func is_empty "${TEST_FAIL}" "${TEST_EMPTY}" TESTARY
TESTARY+=( 'bar' )
assert_func is_empty "${TEST_FAIL}" "${TEST_EMPTY}" TESTARY
unset -v TESTARY

declare -g -A TESTARY=()
assert_func is_empty "${TEST_OK}" "${TEST_EMPTY}" TESTARY
TESTARY+=( ['key0']='foo' )
assert_func is_empty "${TEST_FAIL}" "${TEST_EMPTY}" TESTARY
TESTARY+=( ['key1']='bar' )
assert_func is_empty "${TEST_FAIL}" "${TEST_EMPTY}" TESTARY
unset -v TESTARY
