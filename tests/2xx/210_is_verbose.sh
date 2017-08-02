#!/bin/bash

. common.sh

unset -v VERBOSE
assert_func is_verbose $TEST_FALSE $TEST_EMPTY
VERBOSE=1
assert_func is_verbose $TEST_TRUE $TEST_EMPTY
unset -v VERBOSE
