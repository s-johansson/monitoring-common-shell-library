#!/bin/bash

. common.sh

assert_func eval_results "${TEST_OK}" "${TEST_EMPTY}"
declare -g CSL_EXIT_NO_DATA_IS_CRITICAL=false
assert_func eval_results "${TEST_OK}" "${TEST_EMPTY}"
CSL_EXIT_NO_DATA_IS_CRITICAL=true

#
# remember: we check here if the function eval_results() returns
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
declare -g CSL_WARNING_LIMIT=(
   ['abc']='5:'
)
assert_func eval_results "${TEST_FAIL}" "Unable[[:blank:]]to[[:blank:]]retrieve[[:blank:]]limits"
declare -g CSL_CRITICAL_LIMIT=(
   ['abc']='5:'
)
assert_func eval_results "${TEST_OK}" "${TEST_EMPTY}"
CSL_RESULT_VALUES=()
assert_func eval_results "${TEST_OK}" "${TEST_EMPTY}"
unset -v CSL_RESULT_VALUES CSL_WARNING_LIMIT CSL_CRITICAL_LIMIT
