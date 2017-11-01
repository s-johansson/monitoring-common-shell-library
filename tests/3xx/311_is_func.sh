#!/bin/bash

. common.sh

assert_func is_func $TEST_OK $TEST_EMPTY '_csl_cleanup'
assert_func is_func $TEST_FAIL $TEST_EMPTY 'no__csl_cleanup'
assert_func is_func $TEST_FAIL $TEST_EMPTY 'bash'
