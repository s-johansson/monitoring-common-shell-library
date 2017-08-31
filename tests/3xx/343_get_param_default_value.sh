#!/bin/bash

. common.sh

CSL_USER_PARAMS=()
CSL_USER_PARAMS_DEFAULT_VALUES=()
assert_func get_param_default_value "${TEST_FAIL}" "Invalid parameters"
assert_func get_param_default_value "${TEST_FAIL}" "Invalid parameters" FOO BAr
assert_func get_param_default_value "${TEST_FAIL}" "There is no such parameter" FOO
CSL_USER_PARAMS=( ['FOO']='' )
assert_func get_param_default_value "${TEST_FAIL}" "Parameter has no default-value set" FOO
CSL_USER_PARAMS_DEFAULT_VALUES['FOO']='BAR'
assert_func get_param_default_value "${TEST_OK}" 'BAR' FOO

unset -v CSL_USER_PARAMS
unset -v CSL_USER_PARAMS_DEFAULT_VALUES
