#!/bin/bash

. common.sh

assert_func is_cmd $TEST_OK $TEST_EMPTY 'bash'

assert_func is_cmd $TEST_FAIL $TEST_EMPTY
assert_func is_cmd $TEST_FAIL $TEST_EMPTY 'bibidibabidibu'
