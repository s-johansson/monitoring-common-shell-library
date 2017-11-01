#!/bin/bash

. common.sh

assert_func eval_text "${TEST_OK}" "OK" "foo" "bar" "bla"
assert_func eval_text "${TEST_OK}" "OK" "foo" "1" "2"
assert_func eval_text "${TEST_OK}" "OK" "1" "2" "3"

assert_func eval_text "${TEST_WARNING}" "WARNING" "foo" "foo" "bar"
assert_func eval_text "${TEST_WARNING}" "WARNING" "1" "1" "foo"
assert_func eval_text "${TEST_WARNING}" "WARNING" "1" "1" "2"

assert_func eval_text "${TEST_CRITICAL}" "CRITICAL" "bar" "foo" "bar"
assert_func eval_text "${TEST_CRITICAL}" "CRITICAL" "foo" "1" "foo"
assert_func eval_text "${TEST_CRITICAL}" "CRITICAL" "1" "2" "1"
