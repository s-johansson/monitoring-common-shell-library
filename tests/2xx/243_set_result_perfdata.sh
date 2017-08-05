#!/bin/bash

. common.sh

assert_func set_result_perfdata $TEST_FAIL $TEST_EMPTY
assert_func set_result_perfdata $TEST_OK $TEST_EMPTY "BLA"
