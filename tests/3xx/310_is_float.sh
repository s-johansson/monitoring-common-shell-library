#!/bin/bash

. common.sh

assert_func is_float $TEST_OK $TEST_EMPTY 1.1
assert_func is_float $TEST_OK $TEST_EMPTY 1.11343214313
assert_func is_float $TEST_OK $TEST_EMPTY 0.11343214313
assert_func is_float $TEST_OK $TEST_EMPTY 0.0
assert_func is_float $TEST_OK $TEST_EMPTY -0.0
assert_func is_float $TEST_OK $TEST_EMPTY -0.11343214313
assert_func is_float $TEST_OK $TEST_EMPTY -1.11343214313
assert_func is_float $TEST_OK $TEST_EMPTY -1.1

assert_func is_float $TEST_FAIL $TEST_EMPTY 1
assert_func is_float $TEST_FAIL $TEST_EMPTY 100000
assert_func is_float $TEST_FAIL $TEST_EMPTY 0
assert_func is_float $TEST_FAIL $TEST_EMPTY -0
assert_func is_float $TEST_FAIL $TEST_EMPTY -100000
assert_func is_float $TEST_FAIL $TEST_EMPTY -1

assert_func is_float $TEST_FAIL $TEST_EMPTY 1:1
assert_func is_float $TEST_FAIL $TEST_EMPTY -1:-1
assert_func is_float $TEST_FAIL $TEST_EMPTY "bla"
