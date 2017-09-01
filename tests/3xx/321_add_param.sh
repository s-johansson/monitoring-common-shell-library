#!/bin/bash

. common.sh

assert_func add_param "${TEST_FAIL}" "Invalid parameters"
assert_func add_param "${TEST_FAIL}" "Invalid parameters" a
assert_func add_param "${TEST_FAIL}" "Invalid parameters" a b
assert_func add_param "${TEST_FAIL}" "Invalid parameters" a b c d e
assert_func add_param "${TEST_FAIL}" "given short parameter is invalid" abc b c
assert_func add_param "${TEST_FAIL}" "given long parameter is invalid" a "b " c
assert_func add_param "${TEST_FAIL}" "given short parameter is invalid" abc "b " c
assert_func add_param "${TEST_FAIL}" "at least a short or a long option name" '' '' c

assert_func add_param "${TEST_OK}" "${TEST_EMPTY}" "a" '' TEST_BLA
assert_func add_param "${TEST_OK}" "${TEST_EMPTY}" "a" 'aaa' TEST_BLA
assert_func add_param "${TEST_OK}" "${TEST_EMPTY}" "" 'aaa' TEST_BLA
assert_func add_param "${TEST_OK}" "${TEST_EMPTY}" "a:" '' TEST_BLA
assert_func add_param "${TEST_OK}" "${TEST_EMPTY}" "a:" 'aaa' TEST_BLA
assert_func add_param "${TEST_OK}" "${TEST_EMPTY}" "a:" 'aaa:' TEST_BLA
assert_func add_param "${TEST_OK}" "${TEST_EMPTY}" "a" 'aaa:' TEST_BLA
assert_func add_param "${TEST_OK}" "${TEST_EMPTY}" "" 'aaa:' TEST_BLA

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
