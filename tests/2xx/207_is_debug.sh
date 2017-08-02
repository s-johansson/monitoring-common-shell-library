#!/bin/bash

. common.sh

assert_func is_debug $TEST_FALSE $TEST_EMPTY
DEBUG=1
assert_func is_debug $TEST_TRUE $TEST_EMPTY
unset -v DEBUG
