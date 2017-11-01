#!/bin/bash

. common.sh

assert_func add_prereq $TEST_OK $TEST_EMPTY "asfsa\n"
assert_func add_prereq $TEST_OK $TEST_EMPTY "bash"
assert_func add_prereq $TEST_FAIL $TEST_EMPTY
