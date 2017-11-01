#!/bin/bash

. common.sh

assert_func has_param $TEST_FAIL $TEST_EMPTY
assert_func has_param $TEST_FAIL $TEST_EMPTY BLA
