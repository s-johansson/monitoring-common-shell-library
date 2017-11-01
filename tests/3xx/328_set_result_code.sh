#!/bin/bash

. common.sh

assert_func set_result_code $TEST_FAIL $TEST_EMPTY
assert_func set_result_code $TEST_FAIL $TEST_EMPTY "BLA"
assert_func set_result_code $TEST_OK $TEST_EMPTY "0"
