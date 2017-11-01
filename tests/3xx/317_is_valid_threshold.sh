#!/bin/bash

. common.sh

assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 5
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 0.0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 5.0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" -0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" -5.0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" -0.0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" -5.0

assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 0:
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" :0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 5
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 5:
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" :5
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" -5
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" -5:
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" :-5
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 5.1
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 5.1:
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" :5.1
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" -5.1
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" -5.1:
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" :-5.1

assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 0:0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 5:0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 0:5
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 0.0:0.0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 5.1:0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 5.1:0.0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 0:5.1
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 0.0:5.1

assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" -0:0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" -0:-0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" -5:0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 5:-0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" -0:5
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" -0:-5
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" -0.0:0.0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 0.0:-0.0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 0.0:0.0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" -5.1:0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 5.1:-0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" -5.1:-0
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" -0:5.1
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" 0:-5.1
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" -0:-5.1
assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" -0.0:-5.1

assert_func is_valid_threshold "${TEST_OK}" "${TEST_EMPTY}" bla

assert_func is_valid_threshold "${TEST_FAIL}" "${TEST_EMPTY}" bla:5
assert_func is_valid_threshold "${TEST_FAIL}" "${TEST_EMPTY}" "bla bla"
assert_func is_valid_threshold "${TEST_FAIL}" "${TEST_EMPTY}" bla bla
assert_func is_valid_threshold "${TEST_FAIL}" "${TEST_EMPTY}" x:5
assert_func is_valid_threshold "${TEST_FAIL}" "${TEST_EMPTY}" 5:x
assert_func is_valid_threshold "${TEST_FAIL}" "${TEST_EMPTY}" x:x
assert_func is_valid_threshold "${TEST_FAIL}" "${TEST_EMPTY}" -0.x
assert_func is_valid_threshold "${TEST_FAIL}" "${TEST_EMPTY}" -5.x
