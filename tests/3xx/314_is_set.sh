#!/bin/bash

. common.sh

assert_func is_set $TEST_OK $TEST_EMPTY 0
assert_func is_set $TEST_OK $TEST_EMPTY -0
assert_func is_set $TEST_OK $TEST_EMPTY 1 2 3
assert_func is_set $TEST_OK $TEST_EMPTY 1
assert_func is_set $TEST_OK $TEST_EMPTY -1
assert_func is_set $TEST_OK $TEST_EMPTY 0.0
assert_func is_set $TEST_OK $TEST_EMPTY -0.0
assert_func is_set $TEST_OK $TEST_EMPTY 1.1 2.2 3.3
assert_func is_set $TEST_OK $TEST_EMPTY -1.1 -2.2 -3.3
assert_func is_set $TEST_OK $TEST_EMPTY bla

assert_func is_set $TEST_FAIL $TEST_EMPTY 1 x 3
assert_func is_set $TEST_FAIL $TEST_EMPTY x
