#!/bin/bash

. common.sh

assert_func is_empty_str "${TEST_FAIL}" "${TEST_EMPTY}"
assert_func is_empty_str "${TEST_FAIL}" "${TEST_EMPTY}" '/tmp' 'bla'

assert_func is_empty_str "${TEST_OK}" "${TEST_EMPTY}" ''
assert_func is_empty_str "${TEST_FAIL}" "${TEST_EMPTY}" 'foo'
