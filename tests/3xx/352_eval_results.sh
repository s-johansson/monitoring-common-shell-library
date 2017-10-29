#!/bin/bash

. common.sh

assert_func eval_results "${TEST_OK}" "${TEST_EMPTY}"
declare -g CSL_EXIT_NO_DATA_IS_CRITICAL=false
assert_func eval_results "${TEST_OK}" "${TEST_EMPTY}"
CSL_EXIT_NO_DATA_IS_CRITICAL=true


## remember: we check here if the function eval_results() returns
# correctly as desired. we do not check if the plugin-output, -code
# or perfdata have been set.
#
assert_func eval_results "${TEST_OK}" "${TEST_EMPTY}"
unset -v CSL_EXIT_NO_DATA_IS_CRITICAL

CSL_RESULT_VALUES=()
assert_func eval_results "${TEST_OK}" "${TEST_EMPTY}"
CSL_RESULT_VALUES+=( ['abc']='123' )
assert_func eval_results "${TEST_FAIL}" "No[[:blank:]]plugin[[:blank:]]results[[:blank:]]have[[:blank:]]been[[:blank:]]evaluated"
CSL_RESULT_VALUES+=( ['abc']='123' )
declare -g -A CSL_WARNING_THRESHOLD=(
   ['abc']='5:'
)
assert_func eval_results "${TEST_FAIL}" "Unable[[:blank:]]to[[:blank:]]retrieve[[:blank:]]thresholds"
declare -g -A CSL_CRITICAL_THRESHOLD=(
   ['abc']='5:'
)
assert_func eval_results "${TEST_OK}" "${TEST_EMPTY}"
CSL_RESULT_VALUES=()
assert_func eval_results "${TEST_OK}" "${TEST_EMPTY}"

declare -g -A CSL_RESULT_VALUES=(
   ['abc']='123dBmV'
   ['def']='12.34dBmV'
   ['ghi']='123 dBmV'
   ['jkl']='12.34 dBmV'
)

declare -g -A CSL_WARNING_THRESHOLD=(
   ['abc']='50:'
   ['def']=':5'
   ['ghi']=':50'
   ['jkl']=':5'
)
declare -g -A CSL_CRITICAL_THRESHOLD=(
   ['abc']=':100'
   ['def']=':10'
   ['ghi']=':100'
   ['jkl']=':10'
)

assert_func eval_results "${TEST_OK}" "${TEST_EMPTY}"
unset -v CSL_RESULT_VALUES CSL_WARNING_THRESHOLD CSL_CRITICAL_THRESHOLD
