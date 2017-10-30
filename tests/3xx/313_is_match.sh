#!/bin/bash

. common.sh

# positive integer compare
assert_func is_match $TEST_OK $TEST_EMPTY "2 > 1"
assert_func is_match $TEST_OK $TEST_EMPTY "2 >= 1"
assert_func is_match $TEST_OK $TEST_EMPTY "2 >= 2"
assert_func is_match $TEST_OK $TEST_EMPTY "1 < 2"
assert_func is_match $TEST_OK $TEST_EMPTY "1 <= 2"
assert_func is_match $TEST_OK $TEST_EMPTY "1 <= 1"
assert_func is_match $TEST_OK $TEST_EMPTY "2 == 2"
assert_func is_match $TEST_OK $TEST_EMPTY "2 != 1"
# negative integer compare
assert_func is_match $TEST_OK $TEST_EMPTY "-2 < -1"
assert_func is_match $TEST_OK $TEST_EMPTY "-2 <= -1"
assert_func is_match $TEST_OK $TEST_EMPTY "-2 <= -2"
assert_func is_match $TEST_OK $TEST_EMPTY "-1 > -2"
assert_func is_match $TEST_OK $TEST_EMPTY "-1 >= -2"
assert_func is_match $TEST_OK $TEST_EMPTY "-1 >= -1"
assert_func is_match $TEST_OK $TEST_EMPTY "-2 == -2"
assert_func is_match $TEST_OK $TEST_EMPTY "-2 != -1"
# mixed integer compare
assert_func is_match $TEST_OK $TEST_EMPTY "-2 < 1"
assert_func is_match $TEST_OK $TEST_EMPTY "-2 <= 1"
assert_func is_match $TEST_OK $TEST_EMPTY "2 > -3"
assert_func is_match $TEST_OK $TEST_EMPTY "2 >= -3"
assert_func is_match $TEST_OK $TEST_EMPTY "-2 != -1"

# positive float compare
assert_func is_match $TEST_OK $TEST_EMPTY "2.3 > 1.2"
assert_func is_match $TEST_OK $TEST_EMPTY "2.3 >= 1.2"
assert_func is_match $TEST_OK $TEST_EMPTY "2.3 >= 2.3"
assert_func is_match $TEST_OK $TEST_EMPTY "1.2 < 2.3"
assert_func is_match $TEST_OK $TEST_EMPTY "1.2 <= 2.3"
assert_func is_match $TEST_OK $TEST_EMPTY "1.2 <= 1.2"
assert_func is_match $TEST_OK $TEST_EMPTY "2.3 == 2.3"
assert_func is_match $TEST_OK $TEST_EMPTY "2.3 != 1.2"
# negative float compare
assert_func is_match $TEST_OK $TEST_EMPTY "-2.3 < -1.2"
assert_func is_match $TEST_OK $TEST_EMPTY "-2.3 <= -1.2"
assert_func is_match $TEST_OK $TEST_EMPTY "-2.3 <= -2.3"
assert_func is_match $TEST_OK $TEST_EMPTY "-1.2 > -2.3"
assert_func is_match $TEST_OK $TEST_EMPTY "-1.2 >= -2.3"
assert_func is_match $TEST_OK $TEST_EMPTY "-1.2 >= -1.2"
assert_func is_match $TEST_OK $TEST_EMPTY "-2.3 == -2.3"
assert_func is_match $TEST_OK $TEST_EMPTY "-2.3 != -1.2"
# mixed float compare
assert_func is_match $TEST_OK $TEST_EMPTY "-2.3 < 1.2"
assert_func is_match $TEST_OK $TEST_EMPTY "-2.3 <= 1.2"
assert_func is_match $TEST_OK $TEST_EMPTY "2.3 > -3"
assert_func is_match $TEST_OK $TEST_EMPTY "2.3 >= -3"
assert_func is_match $TEST_OK $TEST_EMPTY "-2.3 != -1.2"

assert_func is_match $TEST_FAIL "unexpected result" "5"
assert_func is_match $TEST_FAIL $TEST_EMPTY "x5"
assert_func is_match $TEST_FAIL $TEST_EMPTY "bla"
assert_func is_match $TEST_FAIL "illegal character" "5:5"
assert_func is_match $TEST_FAIL "illegal character" "-5:-5"
