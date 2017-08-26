#!/bin/bash

. common.sh

assert_func is_array $TEST_FAIL $TEST_EMPTY
assert_func is_array $TEST_FAIL $TEST_EMPTY bla
assert_func is_array $TEST_FAIL $TEST_EMPTY foo bar
declare -a -g TEST_ARY=()
assert_func is_array $TEST_OK $TEST_EMPTY TEST_ARY
TEST_ARY+=( 'bla' )
assert_func is_array $TEST_OK $TEST_EMPTY TEST_ARY
unset -v TEST_ARY
assert_func is_array $TEST_FAIL $TEST_EMPTY TEST_ARY
