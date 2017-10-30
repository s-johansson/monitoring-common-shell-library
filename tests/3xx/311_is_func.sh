#!/bin/bash

. common.sh

assert_func is_func $TEST_OK $TEST_EMPTY 'csl_cleanup'
assert_func is_func $TEST_FAIL $TEST_EMPTY 'no_csl_cleanup'
assert_func is_func $TEST_FAIL $TEST_EMPTY 'bash'
