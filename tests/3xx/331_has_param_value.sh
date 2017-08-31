#!/bin/bash

. common.sh

assert_func has_param_value "${TEST_FAIL}" "Invalid parameters"
assert_func has_param_value "${TEST_FAIL}" "Invalid parameters" a b
assert_func has_param_value "${TEST_FAIL}" "There is no such parameter" BAR
add_param -t --test FOO
assert_func has_param_value "${TEST_FAIL}" "There is no such parameter" FOO
CSL_USER_PARAMS['FOO']='BAR'
assert_func has_param_value "${TEST_OK}" "${TEST_EMPTY}" FOO

unset -f CSL_USER_PARAMS
