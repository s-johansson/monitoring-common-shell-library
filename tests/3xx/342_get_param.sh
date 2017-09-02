#!/bin/bash

. common.sh

CSL_USER_PARAMS=()
CSL_USER_PARAMS_VALUES=()
CSL_USER_PARAMS_DEFAULT_VALUES=()
assert_func get_param "${TEST_FAIL}" "Invalid parameters"
assert_func get_param "${TEST_FAIL}" "Invalid parameters" FOO BAR
assert_func get_param "${TEST_FAIL}" "There is no such parameter" FOO

CSL_USER_PARAMS+=( 'FOO' )
CSL_USER_PARAMS_VALUES['FOO']=''
CSL_USER_GETOPT_PARAMS=(
   ['-t']='FOO'
   ['--test']='FOO'
)
assert_func get_param "${TEST_FAIL}" "Parameter has no value set" FOO

CSL_USER_PARAMS_DEFAULT_VALUES['FOO']='BLA'
assert_func get_param "${TEST_OK}" "BLA" FOO

unset -v CSL_USER_PARAMS_DEFAULT_VALUES['FOO']
assert_func get_param "${TEST_FAIL}" "Parameter has no value set" FOO
CSL_USER_PARAMS_VALUES['FOO']='BAR'

assert_func get_param "${TEST_OK}" "BAR" FOO
assert_func get_param "${TEST_OK}" "BAR" '-t'
assert_func get_param "${TEST_OK}" "BAR" '--test'
assert_func get_param "${TEST_FAIL}" "There is no such parameter" '-x'
assert_func get_param "${TEST_FAIL}" "There is no such parameter" '--testx'
assert_func get_param "${TEST_FAIL}" "There is no such parameter" BAR

unset -f CSL_USER_PARAMS CSL_USER_PARAMS_VALUES CSL_USER_PARAMS_DEFAULT_VALUES
