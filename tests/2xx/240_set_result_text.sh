#!/bin/bash

. common.sh

assert_func set_result_text $TEST_FAIL $TEST_EMPTY
assert_func set_result_text $TEST_OK $TEST_EMPTY "BLA"
assert_func set_result_text $TEST_OK $TEST_EMPTY <<<"BLA"
