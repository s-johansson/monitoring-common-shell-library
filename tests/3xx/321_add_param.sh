#!/bin/bash

. common.sh

assert_func add_param "${TEST_FAIL}" "3 or 4 parameters are required"
assert_func add_param "${TEST_FAIL}" "3 or 4 parameters are required" a
assert_func add_param "${TEST_FAIL}" "3 or 4 parameters are required" a b
assert_func add_param "${TEST_FAIL}" "given short parameter is invalid" abc b c
assert_func add_param "${TEST_FAIL}" "given long parameter is invalid" a "b " c
assert_func add_param "${TEST_FAIL}" "given short parameter is invalid" abc "b " c
assert_func add_param "${TEST_FAIL}" "at least a short or a long option name" '' '' c

cesar_test ()
{
   return 0
}

assert_func add_param "${TEST_OK}" "${TEST_EMPTY}" "a" '' cesar_test
assert_func add_param "${TEST_OK}" "${TEST_EMPTY}" "a:" '' cesar_test
assert_func add_param "${TEST_OK}" "${TEST_EMPTY}" "a::" '' cesar_test
assert_func add_param "${TEST_FAIL}" "given short parameter is invalid" ":a" '' cesar_test
assert_func add_param "${TEST_OK}" "${TEST_EMPTY}" "a:" "cesar" cesar_test
assert_func add_param "${TEST_OK}" "${TEST_EMPTY}" '' "cesar:" cesar_test
assert_func add_param "${TEST_OK}" "${TEST_EMPTY}" "a::" "cesar" cesar_test
assert_func add_param "${TEST_OK}" "${TEST_EMPTY}" '' "cesar::" cesar_test
assert_func add_param "${TEST_FAIL}" "given long parameter is invalid" '' ':cesar' cesar_test

unset -f cesar_test
