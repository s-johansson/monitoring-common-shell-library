#!/bin/bash

. common.sh

assert_func is_declared $TEST_TRUE $TEST_EMPTY LOGNAME

unset -v SOME_UNKNOWN_VARIABLE
assert_func is_declared $TEST_FALSE $TEST_EMPTY SOME_UNKNOWN_VARIABLE
assert_func is_declared $TEST_FALSE $TEST_EMPTY
