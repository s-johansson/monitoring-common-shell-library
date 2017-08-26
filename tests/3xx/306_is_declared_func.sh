#!/bin/bash

. common.sh

unset -f foobar
assert_func is_declared_func "${TEST_FAIL}" "${TEST_EMPTY}"
assert_func is_declared_func "${TEST_FAIL}" "${TEST_EMPTY}" foo bar

foobar ()
{
   return 0
}

assert_func is_declared_func "${TEST_OK}" "${TEST_EMPTY}" foobar
unset -f foobar
assert_func is_declared_func "${TEST_FAIL}" "${TEST_EMPTY}" foobar
