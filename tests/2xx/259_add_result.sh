#!/bin/bash

. common.sh

assert_func add_result "${TEST_FAIL}" "Invalid[[:blank:]]parameters"
assert_func add_result "${TEST_FAIL}" "Invalid[[:blank:]]parameters" foo
assert_func add_result "${TEST_FAIL}" "Invalid[[:blank:]]parameters" 'fo o' bar
assert_func add_result "${TEST_FAIL}" "Invalid[[:blank:]]parameters" foo bar bla

assert_func add_result "${TEST_OK}" "${TEST_EMPTY}" foo bar
assert_func add_result "${TEST_OK}" "${TEST_EMPTY}" foo 123
assert_func add_result "${TEST_OK}" "${TEST_EMPTY}" foo_bar bla
assert_func add_result "${TEST_OK}" "${TEST_EMPTY}" foo_bar 'bla_blub'
