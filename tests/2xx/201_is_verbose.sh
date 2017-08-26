#!/bin/bash

. common.sh

unset -v CSL_VERBOSE
assert_func is_verbose $TEST_FALSE $TEST_EMPTY
CSL_VERBOSE=1
assert_func is_verbose $TEST_TRUE $TEST_EMPTY
unset -v CSL_VERBOSE
