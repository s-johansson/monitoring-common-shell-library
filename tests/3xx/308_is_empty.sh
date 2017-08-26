#!/bin/bash

. common.sh

assert_func is_empty "${TEST_FAIL}" "${TEST_EMPTY}"
assert_func is_empty "${TEST_FAIL}" "${TEST_EMPTY}" '/tmp' 'bla'
assert_func is_empty "${TEST_OK}" "${TEST_EMPTY}" ''
