#!/bin/bash

. common.sh

assert_func is_range $TEST_OK $TEST_EMPTY "2:"
assert_func is_range $TEST_OK $TEST_EMPTY ":2"
assert_func is_range $TEST_OK $TEST_EMPTY "2:2"
assert_func is_range $TEST_OK $TEST_EMPTY "1:2"
assert_func is_range $TEST_OK $TEST_EMPTY "2:1"
assert_func is_range $TEST_OK $TEST_EMPTY "0:0"

assert_func is_range $TEST_OK $TEST_EMPTY "-2:"
assert_func is_range $TEST_OK $TEST_EMPTY ":-2"
assert_func is_range $TEST_OK $TEST_EMPTY "-2:-2"
assert_func is_range $TEST_OK $TEST_EMPTY "-1:-2"
assert_func is_range $TEST_OK $TEST_EMPTY "-2:-1"
assert_func is_range $TEST_OK $TEST_EMPTY "-0:-0"

assert_func is_range $TEST_OK $TEST_EMPTY "-2:2"
assert_func is_range $TEST_OK $TEST_EMPTY "1:-2"

assert_func is_range $TEST_OK $TEST_EMPTY "2.3:"
assert_func is_range $TEST_OK $TEST_EMPTY ":2.3"
assert_func is_range $TEST_OK $TEST_EMPTY "2.3:2.3"
assert_func is_range $TEST_OK $TEST_EMPTY "1.2:2.3"
assert_func is_range $TEST_OK $TEST_EMPTY "2.3:1.2"

assert_func is_range $TEST_OK $TEST_EMPTY "-2.3:"
assert_func is_range $TEST_OK $TEST_EMPTY ":-2.3"
assert_func is_range $TEST_OK $TEST_EMPTY "-2.3:-2.3"
assert_func is_range $TEST_OK $TEST_EMPTY "-1.2:-2.3"
assert_func is_range $TEST_OK $TEST_EMPTY "-2.3:-1.2"

assert_func is_range $TEST_OK $TEST_EMPTY "-2.3:2.3"
assert_func is_range $TEST_OK $TEST_EMPTY "1.2:-2.3"


assert_func is_range $TEST_FAIL $TEST_EMPTY "2"
assert_func is_range $TEST_FAIL $TEST_EMPTY "-2"
assert_func is_range $TEST_FAIL $TEST_EMPTY "x"
assert_func is_range $TEST_FAIL $TEST_EMPTY "x:"
assert_func is_range $TEST_FAIL $TEST_EMPTY ":x"
assert_func is_range $TEST_FAIL $TEST_EMPTY "x:x"
assert_func is_range $TEST_FAIL $TEST_EMPTY "bla"
