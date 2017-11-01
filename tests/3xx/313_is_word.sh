#!/bin/bash

. common.sh

assert_func is_word "${TEST_FAIL}" "${TEST_EMPTY}" "!§"
assert_func is_word "${TEST_FAIL}" "${TEST_EMPTY}" "foo bar"
assert_func is_word "${TEST_FAIL}" "${TEST_EMPTY}" "foo_1"
assert_func is_word "${TEST_FAIL}" "${TEST_EMPTY}" "foo bar bla"

assert_func is_word "${TEST_OK}" "${TEST_EMPTY}" 1
assert_func is_word "${TEST_OK}" "${TEST_EMPTY}" 12
assert_func is_word "${TEST_OK}" "${TEST_EMPTY}" 123

assert_func is_word "${TEST_OK}" "${TEST_EMPTY}" a
assert_func is_word "${TEST_OK}" "${TEST_EMPTY}" ab
assert_func is_word "${TEST_OK}" "${TEST_EMPTY}" abc

assert_func is_word "${TEST_OK}" "${TEST_EMPTY}" 1a
assert_func is_word "${TEST_OK}" "${TEST_EMPTY}" ab1
assert_func is_word "${TEST_OK}" "${TEST_EMPTY}" abc
