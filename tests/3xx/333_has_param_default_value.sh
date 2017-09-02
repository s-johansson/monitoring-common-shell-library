#!/bin/bash

. common.sh

CSL_USER_PARAMS=()
CSL_USER_PARAMS_VALUES=()
CSL_USER_PARAMS_DEFAULT_VALUES=()

assert_func has_param_default_value "${TEST_FAIL}" "Invalid parameters"
assert_func has_param_default_value "${TEST_FAIL}" "Invalid parameters" a b
assert_func has_param_default_value "${TEST_FAIL}" "There is no such parameter" BAR
add_param -t --test FOO
assert_func has_param_default_value "${TEST_FAIL}" "${TEST_EMPTY}" FOO

CSL_USER_PARAMS+=( 'FOO' )
CSL_USER_PARAMS_VALUES['FOO']='BAR'
assert_func has_param_default_value "${TEST_FAIL}" "${TEST_EMPTY}" FOO

CSL_USER_PARAMS_DEFAULT_VALUES['FOO']='BAR'
assert_func has_param_default_value "${TEST_OK}" "${TEST_EMPTY}" FOO

unset -f CSL_USER_PARAMS CSL_USER_PARAMS_VALUES CSL_USER_PARAMS_DEFAULT_VALUES
