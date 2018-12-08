#!/bin/bash

. common.sh

CSL_VERBOSE=false
assert_func is_verbose $TEST_FALSE $TEST_EMPTY
CSL_VERBOSE=true
assert_func is_verbose $TEST_TRUE $TEST_EMPTY
CSL_VERBOSE=false
assert_func is_verbose $TEST_FALSE $TEST_EMPTY
